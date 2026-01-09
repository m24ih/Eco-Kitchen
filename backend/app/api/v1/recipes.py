from typing import List
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload

from app.core.database import get_db
from app.models.recipe import Recipe
from app.models.recipe_ingredient import RecipeIngredient
from app.schemas.recipe import RecipeListOut, RecipeOut, RecipeIngredientOut

router = APIRouter()


@router.get("/", response_model=List[RecipeListOut])
async def list_recipes(
    featured: bool | None = Query(default=None), # ARAMA SEKMESI ÖNE ÇIKAN YEMEKLERİ GÖSTERMEK İÇİN KULLANILACAK
    limit: int = Query(default=20, ge=1, le=50), # KAÇ TANE ÖNE ÇIKAN YEMEK GÖSTERİLCEK
    offset: int = Query(default=0, ge=0), # SAYFALAMA İÇİN KULLANILACAK
    db: AsyncSession = Depends(get_db)
):
    query = select(Recipe)
    if featured is not None:
        query = query.where(Recipe.is_featured == featured)
    query = query.limit(limit).offset(offset)
    result = await db.execute(query)
    return result.scalars().all()


@router.get("/{recipe_id}", response_model=RecipeOut)
async def read_recipe(
    recipe_id: int,
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(Recipe)
        .where(Recipe.id == recipe_id)
        .options(
            selectinload(Recipe.ingredients).selectinload(RecipeIngredient.ingredient)
        )
    )
    recipe = result.scalars().first()
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")

    ingredients = [
        RecipeIngredientOut(
            ingredient_id=ri.ingredient_catalog_id,
            name=ri.ingredient.name,
            quantity=ri.quantity,
            unit=ri.ingredient.default_unit,
        )
        for ri in recipe.ingredients
    ]

    return RecipeOut(
        id=recipe.id,
        name=recipe.name,
        image_url=recipe.image_url,
        instructions=recipe.instructions,
        servings=recipe.servings,
        prep_time_minutes=recipe.prep_time_minutes,
        cook_time_minutes=recipe.cook_time_minutes,
        difficulty=recipe.difficulty,
        is_featured=recipe.is_featured,
        ingredients=ingredients,
    )
