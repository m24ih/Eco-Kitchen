# Run: python3 -m app.seed_recipes
import asyncio
from typing import Dict, List

from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import SessionLocal
from app.models.recipe import Recipe
from app.models.recipe_ingredient import RecipeIngredient
from app.models.ingredient_catalog import IngredientCatalog


RECIPES: List[Dict] = [
    {
        "name": "Scrambled Eggs",
        "image_url": "",
        "instructions": "Whisk eggs with milk, season, then cook in butter over low heat until softly set.",
        "servings": 2,
        "prep_time_minutes": 5,
        "cook_time_minutes": 5,
        "difficulty": "easy",
        "is_featured": True,
        "ingredients": [
            {"name": "egg", "quantity": 4.0},
            {"name": "milk", "quantity": 30.0},
            {"name": "butter", "quantity": 10.0},
            {"name": "salt", "quantity": 2.0},
            {"name": "black pepper", "quantity": 1.0},
        ],
    },
    {
        "name": "Omelette",
        "image_url": "",
        "instructions": "Beat eggs with salt, cook in butter, add cheese, fold and serve.",
        "servings": 1,
        "prep_time_minutes": 5,
        "cook_time_minutes": 5,
        "difficulty": "easy",
        "is_featured": False,
        "ingredients": [
            {"name": "egg", "quantity": 3.0},
            {"name": "butter", "quantity": 10.0},
            {"name": "cheddar cheese", "quantity": 30.0},
            {"name": "salt", "quantity": 2.0},
            {"name": "black pepper", "quantity": 1.0},
        ],
    },
    {
        "name": "Pancakes",
        "image_url": "",
        "instructions": "Mix dry and wet ingredients, cook small rounds on a buttered pan until golden.",
        "servings": 3,
        "prep_time_minutes": 10,
        "cook_time_minutes": 10,
        "difficulty": "easy",
        "is_featured": True,
        "ingredients": [
            {"name": "all purpose flour", "quantity": 200.0},
            {"name": "milk", "quantity": 250.0},
            {"name": "egg", "quantity": 2.0},
            {"name": "butter", "quantity": 20.0},
            {"name": "sugar", "quantity": 20.0},
            {"name": "baking powder", "quantity": 8.0},
            {"name": "salt", "quantity": 2.0},
        ],
    },
    {
        "name": "French Toast",
        "image_url": "",
        "instructions": "Whisk eggs, milk, sugar, and cinnamon. Dip bread and pan-fry in butter.",
        "servings": 2,
        "prep_time_minutes": 5,
        "cook_time_minutes": 10,
        "difficulty": "easy",
        "is_featured": False,
        "ingredients": [
            {"name": "bread", "quantity": 4.0},
            {"name": "egg", "quantity": 2.0},
            {"name": "milk", "quantity": 100.0},
            {"name": "butter", "quantity": 15.0},
            {"name": "sugar", "quantity": 10.0},
            {"name": "cinnamon", "quantity": 2.0},
        ],
    },
    {
        "name": "Caesar Salad",
        "image_url": "",
        "instructions": "Toss romaine with a simple dressing, add toasted bread and parmesan.",
        "servings": 2,
        "prep_time_minutes": 15,
        "cook_time_minutes": 5,
        "difficulty": "easy",
        "is_featured": False,
        "ingredients": [
            {"name": "romaine lettuce", "quantity": 1.0},
            {"name": "bread", "quantity": 2.0},
            {"name": "parmesan cheese", "quantity": 30.0},
            {"name": "olive oil", "quantity": 30.0},
            {"name": "lemon", "quantity": 1.0},
            {"name": "garlic", "quantity": 1.0},
            {"name": "salt", "quantity": 2.0},
            {"name": "black pepper", "quantity": 1.0},
        ],
    },
    {
        "name": "Chicken Stir-Fry",
        "image_url": "",
        "instructions": "Stir-fry chicken, add vegetables, season with soy sauce, serve hot.",
        "servings": 3,
        "prep_time_minutes": 15,
        "cook_time_minutes": 12,
        "difficulty": "medium",
        "is_featured": True,
        "ingredients": [
            {"name": "chicken breast", "quantity": 400.0},
            {"name": "bell pepper", "quantity": 1.0},
            {"name": "onion", "quantity": 1.0},
            {"name": "carrot", "quantity": 1.0},
            {"name": "broccoli", "quantity": 1.0},
            {"name": "soy sauce", "quantity": 30.0},
            {"name": "olive oil", "quantity": 20.0},
            {"name": "garlic", "quantity": 2.0},
            {"name": "ginger", "quantity": 10.0},
        ],
    },
    {
        "name": "Spaghetti Aglio e Olio",
        "image_url": "",
        "instructions": "Cook spaghetti, toss with olive oil and garlic, season and serve.",
        "servings": 2,
        "prep_time_minutes": 5,
        "cook_time_minutes": 12,
        "difficulty": "easy",
        "is_featured": False,
        "ingredients": [
            {"name": "spaghetti", "quantity": 200.0},
            {"name": "olive oil", "quantity": 30.0},
            {"name": "garlic", "quantity": 3.0},
            {"name": "salt", "quantity": 3.0},
            {"name": "black pepper", "quantity": 1.0},
        ],
    },
    {
        "name": "Tomato Pasta",
        "image_url": "",
        "instructions": "Cook pasta and toss with warm tomato sauce, garlic, and basil.",
        "servings": 2,
        "prep_time_minutes": 10,
        "cook_time_minutes": 15,
        "difficulty": "easy",
        "is_featured": False,
        "ingredients": [
            {"name": "pasta", "quantity": 200.0},
            {"name": "tomato sauce", "quantity": 200.0},
            {"name": "olive oil", "quantity": 20.0},
            {"name": "garlic", "quantity": 2.0},
            {"name": "basil", "quantity": 5.0},
            {"name": "salt", "quantity": 3.0},
            {"name": "black pepper", "quantity": 1.0},
        ],
    },
    {
        "name": "Tuna Sandwich",
        "image_url": "",
        "instructions": "Mix tuna with mayo and seasoning, layer on bread with lettuce.",
        "servings": 2,
        "prep_time_minutes": 10,
        "cook_time_minutes": 0,
        "difficulty": "easy",
        "is_featured": False,
        "ingredients": [
            {"name": "tuna", "quantity": 200.0},
            {"name": "mayonnaise", "quantity": 30.0},
            {"name": "bread", "quantity": 4.0},
            {"name": "lettuce", "quantity": 1.0},
            {"name": "lemon", "quantity": 1.0},
            {"name": "black pepper", "quantity": 1.0},
            {"name": "salt", "quantity": 2.0},
        ],
    },
    {
        "name": "Guacamole",
        "image_url": "",
        "instructions": "Mash avocado with lime, tomato, onion, cilantro, and salt.",
        "servings": 2,
        "prep_time_minutes": 10,
        "cook_time_minutes": 0,
        "difficulty": "easy",
        "is_featured": True,
        "ingredients": [
            {"name": "avocado", "quantity": 2.0},
            {"name": "lime", "quantity": 1.0},
            {"name": "tomato", "quantity": 1.0},
            {"name": "onion", "quantity": 0.5},
            {"name": "cilantro", "quantity": 5.0},
            {"name": "salt", "quantity": 2.0},
        ],
    },
    {
        "name": "Greek Salad",
        "image_url": "",
        "instructions": "Combine vegetables with feta and olive oil, season and toss.",
        "servings": 2,
        "prep_time_minutes": 15,
        "cook_time_minutes": 0,
        "difficulty": "easy",
        "is_featured": False,
        "ingredients": [
            {"name": "tomato", "quantity": 2.0},
            {"name": "cucumber", "quantity": 1.0},
            {"name": "red onion", "quantity": 0.5},
            {"name": "feta cheese", "quantity": 80.0},
            {"name": "olive oil", "quantity": 20.0},
            {"name": "black pepper", "quantity": 1.0},
            {"name": "salt", "quantity": 2.0},
        ],
    },
    {
        "name": "Lentil Soup",
        "image_url": "",
        "instructions": "Saute vegetables, add lentils and stock, simmer until tender.",
        "servings": 4,
        "prep_time_minutes": 15,
        "cook_time_minutes": 35,
        "difficulty": "easy",
        "is_featured": False,
        "ingredients": [
            {"name": "lentils", "quantity": 250.0},
            {"name": "onion", "quantity": 1.0},
            {"name": "carrot", "quantity": 2.0},
            {"name": "celery", "quantity": 1.0},
            {"name": "garlic", "quantity": 2.0},
            {"name": "olive oil", "quantity": 20.0},
            {"name": "vegetable stock", "quantity": 1000.0},
            {"name": "salt", "quantity": 4.0},
            {"name": "black pepper", "quantity": 2.0},
        ],
    },
    {
        "name": "Chicken Salad",
        "image_url": "",
        "instructions": "Mix cooked chicken with mayo and celery, season and serve.",
        "servings": 2,
        "prep_time_minutes": 10,
        "cook_time_minutes": 0,
        "difficulty": "easy",
        "is_featured": False,
        "ingredients": [
            {"name": "chicken breast", "quantity": 250.0},
            {"name": "mayonnaise", "quantity": 40.0},
            {"name": "celery", "quantity": 0.5},
            {"name": "lemon", "quantity": 1.0},
            {"name": "salt", "quantity": 2.0},
            {"name": "black pepper", "quantity": 1.0},
        ],
    },
    {
        "name": "Fried Rice",
        "image_url": "",
        "instructions": "Stir-fry rice with eggs, vegetables, and soy sauce until hot.",
        "servings": 3,
        "prep_time_minutes": 10,
        "cook_time_minutes": 10,
        "difficulty": "medium",
        "is_featured": False,
        "ingredients": [
            {"name": "rice", "quantity": 300.0},
            {"name": "egg", "quantity": 2.0},
            {"name": "carrot", "quantity": 1.0},
            {"name": "peas", "quantity": 80.0},
            {"name": "scallion", "quantity": 1.0},
            {"name": "soy sauce", "quantity": 30.0},
            {"name": "sesame oil", "quantity": 10.0},
        ],
    },
]
#INSTRUCTIONLARI GUNCELLE!!!!
#INSTRUCTIONLARI GUNCELLE!!!!
#INSTRUCTIONLARI GUNCELLE!!!!
#INSTRUCTIONLARI GUNCELLE!!!!
#INSTRUCTIONLARI GUNCELLE!!!!
#INSTRUCTIONLARI GUNCELLE!!!!
#INSTRUCTIONLARI GUNCELLE!!!!
#INSTRUCTIONLARI GUNCELLE!!!!

#DUZGUN RESIM URLERI BUL VE EKLE!!!!!
#DUZGUN RESIM URLERI BUL VE EKLE!!!!!
#DUZGUN RESIM URLERI BUL VE EKLE!!!!!
#DUZGUN RESIM URLERI BUL VE EKLE!!!!!
#DUZGUN RESIM URLERI BUL VE EKLE!!!!!
#DUZGUN RESIM URLERI BUL VE EKLE!!!!!
#DUZGUN RESIM URLERI BUL VE EKLE!!!!!
#DUZGUN RESIM URLERI BUL VE EKLE!!!!!


async def get_ingredient_id_by_name(session: AsyncSession, name: str) -> int:
    result = await session.execute(
        select(IngredientCatalog.id).where(
            func.lower(IngredientCatalog.name) == name.strip().lower()
        )
    )
    row = result.first()
    if not row:
        print(f"Missing ingredient in catalog: {name}")
        raise ValueError(f"Missing ingredient in catalog: {name}")
    return row[0]


async def seed_recipes(session: AsyncSession) -> int:
    inserted = 0
    for recipe_data in RECIPES:
        existing = await session.execute(
            select(Recipe.id).where(
                func.lower(Recipe.name) == recipe_data["name"].lower()
            )
        )
        if existing.first():
            continue

        recipe = Recipe(
            name=recipe_data["name"],
            image_url=recipe_data["image_url"],
            instructions=recipe_data["instructions"],
            servings=recipe_data["servings"],
            prep_time_minutes=recipe_data["prep_time_minutes"],
            cook_time_minutes=recipe_data["cook_time_minutes"],
            difficulty=recipe_data["difficulty"],
            is_featured=recipe_data["is_featured"],
        )
        session.add(recipe)
        await session.flush()

        for ingredient in recipe_data["ingredients"]:
            ingredient_id = await get_ingredient_id_by_name(session, ingredient["name"])
            session.add(
                RecipeIngredient(
                    recipe_id=recipe.id,
                    ingredient_catalog_id=ingredient_id,
                    quantity=ingredient["quantity"],
                )
            )

        inserted += 1

    if inserted:
        await session.commit()
    return inserted


async def main() -> None:
    async with SessionLocal() as session:
        count = await seed_recipes(session)
        print(f"Seeded {count} recipes.")


if __name__ == "__main__":
    asyncio.run(main())
