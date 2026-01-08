from pydantic import BaseModel, ConfigDict


class InventoryItemBase(BaseModel):
    name: str
    quantity: float
    unit: str


class InventoryItemCreate(InventoryItemBase):
    pass


class InventoryItemOut(InventoryItemBase):
    id: int
    owner_id: int

    model_config = ConfigDict(from_attributes=True)
