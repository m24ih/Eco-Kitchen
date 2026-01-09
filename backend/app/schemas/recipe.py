from typing import List, Optional
from pydantic import BaseModel, ConfigDict


class RecipeIngredientOut(BaseModel):
    ingredient_id: int
    name: str
    quantity: float
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

    model_config = ConfigDict(from_attributes=True)


class RecipeOut(RecipeListOut):
    ingredients: List[RecipeIngredientOut]

    model_config = ConfigDict(from_attributes=True)
