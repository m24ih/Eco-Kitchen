from pydantic import BaseModel, ConfigDict
from typing import Optional

class InventoryItemBase(BaseModel):
    name: str
    quantity: float
    unit: Optional[str] = None # Opsiyonel yapıldı

class InventoryItemCreate(InventoryItemBase):
    pass

class InventoryItemOut(BaseModel):
    id: int
    owner_id: int
    name: str
    quantity: float
    unit: str

    model_config = ConfigDict(from_attributes=True)