from typing import List, Optional
from pydantic import BaseModel, ConfigDict


class StepIngredientOut(BaseModel):
    ingredient_id: int
    name: str
    amount_text: str
    note: Optional[str] = None
    unit: str

    model_config = ConfigDict(from_attributes=True)


class RecipeStepOut(BaseModel):
    step_number: int
    text: str
    ingredients: List[StepIngredientOut]

    model_config = ConfigDict(from_attributes=True)


class RecipeIngredientOut(BaseModel):
    ingredient_id: int
    name: str
    amount_text: str
    note: Optional[str] = None
    quantity: Optional[float] = None
    unit: str

    model_config = ConfigDict(from_attributes=True)


class RecipeListOut(BaseModel):
    id: int
    name: str
    image_url: str
    servings: Optional[int]
    prep_time_minutes: Optional[int]
    cook_time_minutes: Optional[int]
    difficulty: Optional[str]
    is_featured: bool
    calories_kcal: Optional[int] = None
    carbs_g: Optional[float] = None
    protein_g: Optional[float] = None
    fat_g: Optional[float] = None

    model_config = ConfigDict(from_attributes=True)


class RecipeOut(RecipeListOut):
    ingredients: List[RecipeIngredientOut]
    steps: List[RecipeStepOut]

    model_config = ConfigDict(from_attributes=True)
