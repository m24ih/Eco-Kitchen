# Run: python3 -m app.seed_recipes
import asyncio
from typing import Dict, List

from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import SessionLocal
from app.models.recipe import Recipe
from app.models.recipe_ingredient import RecipeIngredient
from app.models.recipe_step import RecipeStep
from app.models.recipe_step_ingredient import RecipeStepIngredient
from app.models.ingredient_catalog import IngredientCatalog


RECIPES: List[Dict] = [
    {
        "name": "Scrambled Eggs",
        "image_url": "https://plus.unsplash.com/premium_photo-1700004501749-85a6db76a1de?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Whisk eggs, cook gently in butter, and season to taste.",
        "servings": 2,
        "prep_time_minutes": 5,
        "cook_time_minutes": 5,
        "difficulty": "easy",
        "is_featured": True,
        "calories_kcal": 320,
        "carbs_g": 2.0,
        "protein_g": 18.0,
        "fat_g": 26.0,
        "steps": [
            {
                "step_number": 1,
                "text": "Whisk eggs with milk, salt, and pepper.",
                "ingredients": [
                    {"name": "egg", "amount_text": "4", "quantity": 4.0},
                    {"name": "milk", "amount_text": "30 ml", "quantity": 30.0},
                    {"name": "salt", "amount_text": "1/2 tsp", "quantity": 2.0},
                    {"name": "black pepper", "amount_text": "1/4 tsp", "quantity": 1.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Melt butter in a nonstick pan over low heat.",
                "ingredients": [
                    {"name": "butter", "amount_text": "1 tbsp", "quantity": 10.0},
                ],
            },
            {
                "step_number": 3,
                "text": "Pour in eggs and stir gently until softly set.",
                "ingredients": [],
            },
            {
                "step_number": 4,
                "text": "Remove from heat and serve immediately.",
                "ingredients": [],
            },
            {
                "step_number": 5,
                "text": "Adjust seasoning if needed.",
                "ingredients": [],
            },
        ],
    },
    {
        "name": "Omelette",
        "image_url": "https://images.unsplash.com/photo-1654472353886-ce1802ff2470?q=80&w=1035&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Beat eggs, cook in butter, add cheese, and fold.",
        "servings": 1,
        "prep_time_minutes": 5,
        "cook_time_minutes": 5,
        "difficulty": "easy",
        "is_featured": False,
        "calories_kcal": 420,
        "carbs_g": 40,
        "protein_g": 5,
        "fat_g": 35,
        "steps": [
            {
                "step_number": 1,
                "text": "Beat eggs with salt and pepper.",
                "ingredients": [
                    {"name": "egg", "amount_text": "3", "quantity": 3.0},
                    {"name": "salt", "amount_text": "1/4 tsp", "quantity": 2.0},
                    {"name": "black pepper", "amount_text": "1/4 tsp", "quantity": 1.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Melt butter in a pan over medium heat.",
                "ingredients": [
                    {"name": "butter", "amount_text": "1 tbsp", "quantity": 10.0},
                ],
            },
            {
                "step_number": 3,
                "text": "Pour in eggs and cook until almost set.",
                "ingredients": [],
            },
            {
                "step_number": 4,
                "text": "Add cheese and fold the omelette.",
                "ingredients": [
                    {"name": "cheddar cheese", "amount_text": "30 g", "quantity": 30.0},
                ],
            },
            {
                "step_number": 5,
                "text": "Slide onto a plate and serve.",
                "ingredients": [],
            },
        ],
    },
    {
        "name": "Pancakes",
        "image_url": "https://images.unsplash.com/photo-1541288097308-7b8e3f58c4c6?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Mix batter, cook on a griddle, and serve warm.",
        "servings": 3,
        "prep_time_minutes": 10,
        "cook_time_minutes": 10,
        "difficulty": "easy",
        "is_featured": True,
        "calories_kcal": 520,
        "carbs_g": 78.0,
        "protein_g": 12.0,
        "fat_g": 18.0,
        "steps": [
            {
                "step_number": 1,
                "text": "Mix flour, sugar, baking powder, and salt.",
                "ingredients": [
                    {"name": "all purpose flour", "amount_text": "200 g", "quantity": 200.0},
                    {"name": "sugar", "amount_text": "20 g", "quantity": 20.0},
                    {"name": "baking powder", "amount_text": "2 tsp", "quantity": 8.0},
                    {"name": "salt", "amount_text": "1/2 tsp", "quantity": 2.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Whisk milk and eggs together.",
                "ingredients": [
                    {"name": "milk", "amount_text": "250 ml", "quantity": 250.0},
                    {"name": "egg", "amount_text": "2", "quantity": 2.0},
                ],
            },
            {
                "step_number": 3,
                "text": "Combine wet and dry ingredients into a smooth batter.",
                "ingredients": [],
            },
            {
                "step_number": 4,
                "text": "Cook pancakes on a buttered pan until golden.",
                "ingredients": [
                    {"name": "butter", "amount_text": "1 tbsp", "quantity": 20.0},
                ],
            },
            {
                "step_number": 5,
                "text": "Serve immediately.",
                "ingredients": [],
            },
        ],
    },
    {
        "name": "French Toast",
        "image_url": "https://images.unsplash.com/photo-1595044643502-616eeebbdff3?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Soak bread in egg mixture and pan-fry.",
        "servings": 2,
        "prep_time_minutes": 5,
        "cook_time_minutes": 10,
        "difficulty": "easy",
        "is_featured": False,
        "calories_kcal": 564,
        "carbs_g": 40,
        "protein_g": 12,
        "fat_g": 54,
        "steps": [
            {
                "step_number": 1,
                "text": "Whisk eggs, milk, sugar, and cinnamon.",
                "ingredients": [
                    {"name": "egg", "amount_text": "2", "quantity": 2.0},
                    {"name": "milk", "amount_text": "100 ml", "quantity": 100.0},
                    {"name": "sugar", "amount_text": "10 g", "quantity": 10.0},
                    {"name": "cinnamon", "amount_text": "1/2 tsp", "quantity": 2.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Dip bread slices in the mixture.",
                "ingredients": [
                    {"name": "bread", "amount_text": "4 slices", "quantity": 4.0},
                ],
            },
            {
                "step_number": 3,
                "text": "Cook in butter until golden.",
                "ingredients": [
                    {"name": "butter", "amount_text": "1 tbsp", "quantity": 15.0},
                ],
            },
            {
                "step_number": 4,
                "text": "Serve warm.",
                "ingredients": [],
            },
            {
                "step_number": 5,
                "text": "Add toppings if desired.",
                "ingredients": [],
            },
        ],
    },
    {
        "name": "Caesar Salad",
        "image_url": "https://images.unsplash.com/photo-1746211108786-ca20c8f80ecd?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Toss romaine with dressing and top with croutons and parmesan.",
        "servings": 2,
        "prep_time_minutes": 15,
        "cook_time_minutes": 5,
        "difficulty": "easy",
        "is_featured": False,
        "calories_kcal": 540,
        "carbs_g": 30,
        "protein_g": 25,
        "fat_g": 5,
        "steps": [
            {
                "step_number": 1,
                "text": "Whisk olive oil, lemon juice, garlic, salt, and pepper.",
                "ingredients": [
                    {"name": "olive oil", "amount_text": "2 tbsp", "quantity": 30.0},
                    {"name": "lemon", "amount_text": "1", "quantity": 1.0},
                    {"name": "garlic", "amount_text": "1 clove", "quantity": 1.0, "note": "minced"},
                    {"name": "salt", "amount_text": "1/2 tsp", "quantity": 2.0},
                    {"name": "black pepper", "amount_text": "1/4 tsp", "quantity": 1.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Toast bread cubes with a little olive oil.",
                "ingredients": [
                    {"name": "bread", "amount_text": "2 slices", "quantity": 2.0},
                    {"name": "olive oil", "amount_text": "1 tsp", "quantity": 5.0},
                ],
            },
            {
                "step_number": 3,
                "text": "Toss romaine with dressing.",
                "ingredients": [
                    {"name": "romaine lettuce", "amount_text": "1 head", "quantity": 1.0},
                ],
            },
            {
                "step_number": 4,
                "text": "Top with croutons and parmesan.",
                "ingredients": [
                    {"name": "parmesan cheese", "amount_text": "30 g", "quantity": 30.0},
                ],
            },
            {
                "step_number": 5,
                "text": "Serve immediately.",
                "ingredients": [],
            },
        ],
    },
    {
        "name": "Chicken Stir-Fry",
        "image_url": "https://plus.unsplash.com/premium_photo-1664475934279-2631a25c42ce?q=80&w=1180&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Stir-fry chicken and vegetables, finish with soy sauce.",
        "servings": 3,
        "prep_time_minutes": 15,
        "cook_time_minutes": 12,
        "difficulty": "medium",
        "is_featured": True,
        "calories_kcal": 480,
        "carbs_g": 22.0,
        "protein_g": 38.0,
        "fat_g": 26.0,
        "steps": [
            {
                "step_number": 1,
                "text": "Slice chicken and season lightly.",
                "ingredients": [
                    {"name": "chicken breast", "amount_text": "400 g", "quantity": 400.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Heat oil and saute garlic and ginger.",
                "ingredients": [
                    {"name": "olive oil", "amount_text": "2 tbsp", "quantity": 20.0},
                    {"name": "garlic", "amount_text": "2 cloves", "quantity": 2.0, "note": "minced"},
                    {"name": "ginger", "amount_text": "1 tbsp", "quantity": 10.0, "note": "grated"},
                ],
            },
            {
                "step_number": 3,
                "text": "Cook chicken until browned.",
                "ingredients": [],
            },
            {
                "step_number": 4,
                "text": "Add vegetables and stir-fry until crisp-tender.",
                "ingredients": [
                    {"name": "bell pepper", "amount_text": "1", "quantity": 1.0, "note": "sliced"},
                    {"name": "onion", "amount_text": "1", "quantity": 1.0, "note": "sliced"},
                    {"name": "carrot", "amount_text": "1", "quantity": 1.0, "note": "thinly sliced"},
                    {"name": "broccoli", "amount_text": "1 head", "quantity": 1.0, "note": "florets"},
                ],
            },
            {
                "step_number": 5,
                "text": "Add soy sauce and toss.",
                "ingredients": [
                    {"name": "soy sauce", "amount_text": "2 tbsp", "quantity": 30.0},
                ],
            },
        ],
    },
    {
        "name": "Spaghetti Aglio e Olio",
        "image_url": "https://plus.unsplash.com/premium_photo-1674511582428-58ce834ce172?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Cook pasta and toss with garlic oil and pepper.",
        "servings": 2,
        "prep_time_minutes": 5,
        "cook_time_minutes": 12,
        "difficulty": "easy",
        "is_featured": False,
        "calories_kcal": 430,
        "carbs_g": 23,
        "protein_g": 4,
        "fat_g": 35,
        "steps": [
            {
                "step_number": 1,
                "text": "Boil spaghetti in salted water.",
                "ingredients": [
                    {"name": "spaghetti", "amount_text": "200 g", "quantity": 200.0},
                    {"name": "salt", "amount_text": "1 tsp", "quantity": 3.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Warm olive oil and garlic in a pan.",
                "ingredients": [
                    {"name": "olive oil", "amount_text": "2 tbsp", "quantity": 30.0},
                    {"name": "garlic", "amount_text": "3 cloves", "quantity": 3.0, "note": "sliced"},
                ],
            },
            {
                "step_number": 3,
                "text": "Toss pasta with garlic oil.",
                "ingredients": [],
            },
            {
                "step_number": 4,
                "text": "Season with black pepper.",
                "ingredients": [
                    {"name": "black pepper", "amount_text": "1/4 tsp", "quantity": 1.0},
                ],
            },
            {
                "step_number": 5,
                "text": "Serve immediately.",
                "ingredients": [],
            },
        ],
    },
    {
        "name": "Tomato Pasta",
        "image_url": "https://unsplash.com/photos/a-white-plate-topped-with-pasta-covered-in-sauce-w0GyGNyGo6Y",
        "instructions": "Cook pasta and toss with tomato sauce, garlic, and basil.",
        "servings": 2,
        "prep_time_minutes": 10,
        "cook_time_minutes": 15,
        "difficulty": "easy",
        "is_featured": False,
        "calories_kcal": 305,
        "carbs_g": 50,
        "protein_g": 10,
        "fat_g": 40,
        "steps": [
            {
                "step_number": 1,
                "text": "Boil pasta in salted water.",
                "ingredients": [
                    {"name": "pasta", "amount_text": "200 g", "quantity": 200.0},
                    {"name": "salt", "amount_text": "1 tsp", "quantity": 3.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Warm olive oil and garlic.",
                "ingredients": [
                    {"name": "olive oil", "amount_text": "2 tbsp", "quantity": 20.0},
                    {"name": "garlic", "amount_text": "2 cloves", "quantity": 2.0, "note": "minced"},
                ],
            },
            {
                "step_number": 3,
                "text": "Add tomato sauce and simmer briefly.",
                "ingredients": [
                    {"name": "tomato sauce", "amount_text": "200 ml", "quantity": 200.0},
                ],
            },
            {
                "step_number": 4,
                "text": "Toss pasta with sauce, add basil and pepper.",
                "ingredients": [
                    {"name": "basil", "amount_text": "1 tbsp", "quantity": 5.0, "note": "chopped"},
                    {"name": "black pepper", "amount_text": "1/4 tsp", "quantity": 1.0},
                ],
            },
            {
                "step_number": 5,
                "text": "Serve warm.",
                "ingredients": [],
            },
        ],
    },
    {
        "name": "Tuna Sandwich",
        "image_url": "https://images.unsplash.com/photo-1558985250-27a406d64cb3?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Mix tuna salad and assemble the sandwich.",
        "servings": 2,
        "prep_time_minutes": 10,
        "cook_time_minutes": 0,
        "difficulty": "easy",
        "is_featured": False,
        "calories_kcal": 330,
        "carbs_g": 30,
        "protein_g": 15,
        "fat_g": 40,
        "steps": [
            {
                "step_number": 1,
                "text": "Mix tuna with mayonnaise, lemon, salt, and pepper.",
                "ingredients": [
                    {"name": "tuna", "amount_text": "200 g", "quantity": 200.0},
                    {"name": "mayonnaise", "amount_text": "2 tbsp", "quantity": 30.0},
                    {"name": "lemon", "amount_text": "1", "quantity": 1.0},
                    {"name": "salt", "amount_text": "1/2 tsp", "quantity": 2.0},
                    {"name": "black pepper", "amount_text": "1/4 tsp", "quantity": 1.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Layer tuna salad on bread with lettuce.",
                "ingredients": [
                    {"name": "bread", "amount_text": "4 slices", "quantity": 4.0},
                    {"name": "lettuce", "amount_text": "2 leaves", "quantity": 1.0},
                ],
            },
            {
                "step_number": 3,
                "text": "Close sandwich and serve.",
                "ingredients": [],
            },
            {
                "step_number": 4,
                "text": "Cut in half if desired.",
                "ingredients": [],
            },
            {
                "step_number": 5,
                "text": "Serve immediately.",
                "ingredients": [],
            },
        ],
    },
    {
        "name": "Guacamole",
        "image_url": "https://images.unsplash.com/photo-1680992071073-cb1696ba8d3e?q=80&w=1774&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Mash avocado and mix with lime, tomato, onion, and cilantro.",
        "servings": 2,
        "prep_time_minutes": 10,
        "cook_time_minutes": 0,
        "difficulty": "easy",
        "is_featured": True,
        "calories_kcal": 240,
        "carbs_g": 12.0,
        "protein_g": 3.0,
        "fat_g": 20.0,
        "steps": [
            {
                "step_number": 1,
                "text": "Mash avocado with lime and salt.",
                "ingredients": [
                    {"name": "avocado", "amount_text": "2", "quantity": 2.0},
                    {"name": "lime", "amount_text": "1", "quantity": 1.0},
                    {"name": "salt", "amount_text": "1/2 tsp", "quantity": 2.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Fold in tomato, onion, and cilantro.",
                "ingredients": [
                    {"name": "tomato", "amount_text": "1", "quantity": 1.0, "note": "diced"},
                    {"name": "onion", "amount_text": "1/2", "quantity": 0.5, "note": "diced"},
                    {"name": "cilantro", "amount_text": "1 tbsp", "quantity": 5.0, "note": "chopped"},
                ],
            },
            {
                "step_number": 3,
                "text": "Taste and adjust seasoning.",
                "ingredients": [],
            },
            {
                "step_number": 4,
                "text": "Serve fresh.",
                "ingredients": [],
            },
            {
                "step_number": 5,
                "text": "Cover with plastic wrap to avoid browning.",
                "ingredients": [],
            },
        ],
    },
    {
        "name": "Greek Salad",
        "image_url": "https://images.unsplash.com/photo-1599021419847-d8a7a6aba5b4?q=80&w=1579&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Combine vegetables with feta, olive oil, and seasoning.",
        "servings": 2,
        "prep_time_minutes": 15,
        "cook_time_minutes": 0,
        "difficulty": "easy",
        "is_featured": False,
        "calories_kcal": 600,
        "carbs_g": 12,
        "protein_g": 30,
        "fat_g": 23,
        "steps": [
            {
                "step_number": 1,
                "text": "Chop tomato, cucumber, and red onion.",
                "ingredients": [
                    {"name": "tomato", "amount_text": "2", "quantity": 2.0},
                    {"name": "cucumber", "amount_text": "1", "quantity": 1.0},
                    {"name": "red onion", "amount_text": "1/2", "quantity": 0.5},
                ],
            },
            {
                "step_number": 2,
                "text": "Add feta and olive oil.",
                "ingredients": [
                    {"name": "feta cheese", "amount_text": "80 g", "quantity": 80.0},
                    {"name": "olive oil", "amount_text": "2 tbsp", "quantity": 20.0},
                ],
            },
            {
                "step_number": 3,
                "text": "Season with salt and pepper, then toss.",
                "ingredients": [
                    {"name": "salt", "amount_text": "1/2 tsp", "quantity": 2.0},
                    {"name": "black pepper", "amount_text": "1/4 tsp", "quantity": 1.0},
                ],
            },
            {
                "step_number": 4,
                "text": "Serve chilled or at room temperature.",
                "ingredients": [],
            },
            {
                "step_number": 5,
                "text": "Add extra olive oil if desired.",
                "ingredients": [],
            },
        ],
    },
    {
        "name": "Lentil Soup",
        "image_url": "https://images.unsplash.com/photo-1642497394078-4794e837019c?q=80&w=1674&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Saute vegetables, add lentils and stock, and simmer.",
        "servings": 4,
        "prep_time_minutes": 15,
        "cook_time_minutes": 35,
        "difficulty": "easy",
        "is_featured": False,
        "calories_kcal": 450,
        "carbs_g": 45,
        "protein_g": 20,
        "fat_g": 15,
        "steps": [
            {
                "step_number": 1,
                "text": "Saute onion, carrot, celery, and garlic in olive oil.",
                "ingredients": [
                    {"name": "onion", "amount_text": "1", "quantity": 1.0, "note": "diced"},
                    {"name": "carrot", "amount_text": "2", "quantity": 2.0, "note": "diced"},
                    {"name": "celery", "amount_text": "1", "quantity": 1.0, "note": "diced"},
                    {"name": "garlic", "amount_text": "2 cloves", "quantity": 2.0, "note": "minced"},
                    {"name": "olive oil", "amount_text": "2 tbsp", "quantity": 20.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Add lentils and vegetable stock.",
                "ingredients": [
                    {"name": "lentils", "amount_text": "250 g", "quantity": 250.0},
                    {"name": "vegetable stock", "amount_text": "1 L", "quantity": 1000.0},
                ],
            },
            {
                "step_number": 3,
                "text": "Simmer until lentils are tender.",
                "ingredients": [],
            },
            {
                "step_number": 4,
                "text": "Season with salt and pepper.",
                "ingredients": [
                    {"name": "salt", "amount_text": "1 tsp", "quantity": 4.0},
                    {"name": "black pepper", "amount_text": "1/2 tsp", "quantity": 2.0},
                ],
            },
            {
                "step_number": 5,
                "text": "Serve hot.",
                "ingredients": [],
            },
        ],
    },
    {
        "name": "Chicken Salad",
        "image_url": "https://images.unsplash.com/photo-1580013759032-c96505e24c1f?q=80&w=1509&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Mix cooked chicken with mayo, celery, and lemon.",
        "servings": 2,
        "prep_time_minutes": 10,
        "cook_time_minutes": 0,
        "difficulty": "easy",
        "is_featured": False,
        "calories_kcal": 390,
        "carbs_g": 25,
        "protein_g": 20,
        "fat_g": 3,
        "steps": [
            {
                "step_number": 1,
                "text": "Shred cooked chicken.",
                "ingredients": [
                    {"name": "chicken breast", "amount_text": "250 g", "quantity": 250.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Mix chicken with mayo, celery, and lemon.",
                "ingredients": [
                    {"name": "mayonnaise", "amount_text": "3 tbsp", "quantity": 40.0},
                    {"name": "celery", "amount_text": "1/2 stalk", "quantity": 0.5, "note": "chopped"},
                    {"name": "lemon", "amount_text": "1", "quantity": 1.0},
                ],
            },
            {
                "step_number": 3,
                "text": "Season with salt and pepper.",
                "ingredients": [
                    {"name": "salt", "amount_text": "1/2 tsp", "quantity": 2.0},
                    {"name": "black pepper", "amount_text": "1/4 tsp", "quantity": 1.0},
                ],
            },
            {
                "step_number": 4,
                "text": "Serve chilled.",
                "ingredients": [],
            },
            {
                "step_number": 5,
                "text": "Pair with greens or bread.",
                "ingredients": [],
            },
        ],
    },
    {
        "name": "Fried Rice",
        "image_url": "https://images.unsplash.com/photo-1603133872878-684f208fb84b?q=80&w=1625&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "instructions": "Stir-fry rice with eggs, vegetables, and soy sauce.",
        "servings": 3,
        "prep_time_minutes": 10,
        "cook_time_minutes": 10,
        "difficulty": "medium",
        "is_featured": False,
        "calories_kcal": 460,
        "carbs_g": 30,
        "protein_g": 13,
        "fat_g": 20,
        "steps": [
            {
                "step_number": 1,
                "text": "Scramble eggs in a little sesame oil.",
                "ingredients": [
                    {"name": "egg", "amount_text": "2", "quantity": 2.0},
                    {"name": "sesame oil", "amount_text": "1 tsp", "quantity": 10.0},
                ],
            },
            {
                "step_number": 2,
                "text": "Stir-fry carrots, peas, and scallion.",
                "ingredients": [
                    {"name": "carrot", "amount_text": "1", "quantity": 1.0, "note": "diced"},
                    {"name": "peas", "amount_text": "1/2 cup", "quantity": 80.0},
                    {"name": "scallion", "amount_text": "1", "quantity": 1.0, "note": "sliced"},
                ],
            },
            {
                "step_number": 3,
                "text": "Add rice and toss.",
                "ingredients": [
                    {"name": "rice", "amount_text": "300 g", "quantity": 300.0},
                ],
            },
            {
                "step_number": 4,
                "text": "Add soy sauce and combine.",
                "ingredients": [
                    {"name": "soy sauce", "amount_text": "2 tbsp", "quantity": 30.0},
                ],
            },
            {
                "step_number": 5,
                "text": "Fold eggs back in and serve.",
                "ingredients": [],
            },
        ],
    },
]


async def get_ingredient_id_by_name(
    session: AsyncSession,
    name: str,
    cache: Dict[str, int]
) -> int:
    key = name.strip().lower()
    if key in cache:
        return cache[key]

    result = await session.execute(
        select(IngredientCatalog.id).where(
            func.lower(IngredientCatalog.name) == key
        )
    )
    row = result.first()
    if not row:
        print(f"Missing ingredient in catalog: {name}")
        raise ValueError(f"Missing ingredient in catalog: {name}")
    cache[key] = row[0]
    return row[0]


async def seed_recipes(session: AsyncSession) -> int:
    inserted = 0
    ingredient_cache: Dict[str, int] = {}

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
            calories_kcal=recipe_data["calories_kcal"],
            carbs_g=recipe_data["carbs_g"],
            protein_g=recipe_data["protein_g"],
            fat_g=recipe_data["fat_g"],
        )
        session.add(recipe)
        await session.flush()

        ingredient_map: Dict[int, Dict] = {}

        for step_data in recipe_data["steps"]:
            step = RecipeStep(
                recipe_id=recipe.id,
                step_number=step_data["step_number"],
                text=step_data["text"],
            )
            session.add(step)
            await session.flush()

            for ingredient in step_data["ingredients"]:
                ingredient_id = await get_ingredient_id_by_name(
                    session,
                    ingredient["name"],
                    ingredient_cache
                )
                session.add(
                    RecipeStepIngredient(
                        step_id=step.id,
                        ingredient_catalog_id=ingredient_id,
                        amount_text=ingredient["amount_text"],
                        note=ingredient.get("note"),
                    )
                )

                if ingredient_id not in ingredient_map:
                    ingredient_map[ingredient_id] = {
                        "amount_text": ingredient["amount_text"],
                        "note": ingredient.get("note"),
                        "quantity": ingredient.get("quantity"),
                    }

        for ingredient_id, data in ingredient_map.items():
            session.add(
                RecipeIngredient(
                    recipe_id=recipe.id,
                    ingredient_catalog_id=ingredient_id,
                    amount_text=data["amount_text"],
                    note=data.get("note"),
                    quantity=data.get("quantity"),
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
