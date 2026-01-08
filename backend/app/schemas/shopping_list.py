from typing import Optional
from pydantic import BaseModel, ConfigDict


class ShoppingListItemCreate(BaseModel):
    name: str
    quantity: float
    unit: Optional[str] = None


class ShoppingListItemOut(BaseModel):
    id: int
    owner_id: int
    name: str
    quantity: float
    unit: str
    is_checked: bool

    model_config = ConfigDict(from_attributes=True)


class ShoppingListItemUpdate(BaseModel):
    quantity: Optional[float] = None
    unit: Optional[str] = None
    is_checked: Optional[bool] = None
