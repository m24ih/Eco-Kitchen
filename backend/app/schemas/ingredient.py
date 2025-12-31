from pydantic import BaseModel, ConfigDict

# Ortak özellikler
class IngredientBase(BaseModel):
    name: str
    quantity: float
    unit: str # kg, gr, adet, lt

# Veri oluştururken istenenler (Base ile aynı)
class IngredientCreate(IngredientBase):
    pass

# Kullanıcıya dönerken göstereceklerimiz (ID ve OwnerID ekli)
class IngredientOut(IngredientBase):
    id: int
    owner_id: int

    model_config = ConfigDict(from_attributes=True)