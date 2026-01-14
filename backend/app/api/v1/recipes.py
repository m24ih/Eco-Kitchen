from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy import desc

from app.core.database import get_db
from app.models.recipe import Recipe
from app.models.recipe_ingredient import RecipeIngredient
from app.models.recipe_step import RecipeStep
from app.models.recipe_step_ingredient import RecipeStepIngredient
from app.schemas.recipe import (
    RecipeListOut,
    RecipeOut,
    RecipeIngredientOut,
    RecipeStepOut,
    StepIngredientOut,
)

router = APIRouter()

@router.get("/", response_model=List[RecipeListOut])
async def list_recipes(
    featured: bool | None = Query(default=None), 
    limit: int = Query(default=20, ge=1, le=50), 
    offset: int = Query(default=0, ge=0),
    sort: str = Query(default="newest", regex="^(newest|oldest)$"), # Sıralama eklendi
    db: AsyncSession = Depends(get_db)
):
    query = select(Recipe)
    
    # Filtreleme
    if featured is not None:
        query = query.where(Recipe.is_featured == featured)
    
    # Sıralama
    if sort == "newest":
        query = query.order_by(desc(Recipe.created_at))
    elif sort == "oldest":
        query = query.order_by(Recipe.created_at)
        
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
            selectinload(Recipe.ingredients).selectinload(RecipeIngredient.ingredient),
            selectinload(Recipe.steps).selectinload(RecipeStep.ingredients).selectinload(
                RecipeStepIngredient.ingredient
            ),
        )
    )
    recipe = result.scalars().first()
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")

    ingredients = [
        RecipeIngredientOut(
            ingredient_id=ri.ingredient_catalog_id,
            name=ri.ingredient.name,
            amount_text=ri.amount_text,
            note=ri.note,
            quantity=ri.quantity,
            unit=ri.ingredient.default_unit,
        )
        for ri in recipe.ingredients
    ]
    # Malzemeleri isme göre sırala
    ingredients.sort(key=lambda item: item.name.lower())
    
    steps = [
        RecipeStepOut(
            step_number=step.step_number,
            text=step.text,
            ingredients=[
                StepIngredientOut(
                    ingredient_id=si.ingredient_catalog_id,
                    name=si.ingredient.name,
                    amount_text=si.amount_text,
                    note=si.note,
                    unit=si.ingredient.default_unit,
                )
                for si in sorted(step.ingredients, key=lambda s: s.ingredient.name.lower())
            ],
        )
        for step in recipe.steps
    ]
    # Adımları numarasına göre sırala
    steps.sort(key=lambda x: x.step_number)

    return RecipeOut(
        id=recipe.id,
        name=recipe.name,
        image_url=recipe.image_url,
        servings=recipe.servings,
        prep_time_minutes=recipe.prep_time_minutes,
        cook_time_minutes=recipe.cook_time_minutes,
        difficulty=recipe.difficulty,
        is_featured=recipe.is_featured,
        calories_kcal=recipe.calories_kcal,
        carbs_g=recipe.carbs_g,
        protein_g=recipe.protein_g,
        fat_g=recipe.fat_g,
        ingredients=ingredients,
        steps=steps,
    )