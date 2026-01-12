from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.core.database import get_db
from app.api.deps import get_current_user
from app.models.user import User
from app.models.recipe import Recipe
from app.models.favorite_recipe import FavoriteRecipe
from app.schemas.favorites import FavoriteRecipeOut

router = APIRouter()


def _to_favorite_out(favorite: FavoriteRecipe, recipe: Recipe | None = None) -> FavoriteRecipeOut:
    return FavoriteRecipeOut(
        id=favorite.id,
        owner_id=favorite.owner_id,
        recipe_id=favorite.recipe_id,
        created_at=favorite.created_at,
        recipe_name=recipe.name if recipe else None,
        recipe_image_url=recipe.image_url if recipe else None,
    )


@router.post(
    "/recipes/{recipe_id}",
    response_model=FavoriteRecipeOut,
    status_code=status.HTTP_201_CREATED
)
async def add_favorite_recipe(
    recipe_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    result = await db.execute(select(Recipe).where(Recipe.id == recipe_id))
    recipe = result.scalars().first()
    #Eğer mevcut recipe.id yoksa hata versin. (Swagger da görelim ne oluyor.)
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")

    result = await db.execute(
        select(FavoriteRecipe).where(
            FavoriteRecipe.owner_id == current_user.id,
            FavoriteRecipe.recipe_id == recipe_id,
        )
    )
    favorite = result.scalars().first()
    if favorite:
        raise HTTPException(status_code=409, detail="Already favorited")

    favorite = FavoriteRecipe(owner_id=current_user.id, recipe_id=recipe_id)
    db.add(favorite)
    try:
        await db.commit()
    except IntegrityError:
        await db.rollback()
        result = await db.execute(
            select(FavoriteRecipe).where(
                FavoriteRecipe.owner_id == current_user.id,
                FavoriteRecipe.recipe_id == recipe_id,
            )
        )
        favorite = result.scalars().first()
        if not favorite:
            raise
        raise HTTPException(status_code=409, detail="Already favorited")

    await db.refresh(favorite)
    return favorite


@router.delete("/recipes/{recipe_id}", status_code=status.HTTP_204_NO_CONTENT)
async def remove_favorite_recipe(
    recipe_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    result = await db.execute(
        select(FavoriteRecipe).where(
            FavoriteRecipe.owner_id == current_user.id,
            FavoriteRecipe.recipe_id == recipe_id,
        )
    )
    favorite = result.scalars().first()
    #Eğer varolmayan bir favori girilirse yine hata döndürsün. (Swagger için)
    if not favorite:
        raise HTTPException(status_code=404, detail="Favorite not found")

    await db.delete(favorite)
    await db.commit()


@router.get("/recipes", response_model=List[FavoriteRecipeOut])
async def list_favorite_recipes(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    result = await db.execute(
        select(FavoriteRecipe, Recipe)
        .join(Recipe, FavoriteRecipe.recipe_id == Recipe.id)
        .where(FavoriteRecipe.owner_id == current_user.id)
        .order_by(FavoriteRecipe.created_at.desc())
    )
    return [_to_favorite_out(fav, recipe) for fav, recipe in result.all()]
