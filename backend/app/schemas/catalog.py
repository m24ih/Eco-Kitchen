from typing import List, Optional
from pydantic import BaseModel, ConfigDict


class CatalogItemOut(BaseModel):
    id: int
    name: str
    default_unit: str
    aliases: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)


class CatalogSearchOut(BaseModel):
    items: List[CatalogItemOut]

    model_config = ConfigDict(from_attributes=True)
