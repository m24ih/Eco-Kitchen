from datetime import datetime
from typing import Optional
from pydantic import BaseModel, ConfigDict


class FavoriteRecipeOut(BaseModel):
    id: int
    owner_id: int
    recipe_id: int
    created_at: datetime
    recipe_name: Optional[str] = None
    recipe_image_url: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)
