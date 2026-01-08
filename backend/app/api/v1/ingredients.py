from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List

from app.core.database import get_db
from app.api.deps import get_current_user
from app.models.user import User
from app.models.inventory_item import InventoryItem
from app.schemas.ingredient import IngredientCreate, IngredientOut

router = APIRouter()

# 1. Malzeme Ekleme
@router.post("/", response_model=IngredientOut, status_code=status.HTTP_201_CREATED)
async def create_ingredient(
    ingredient: IngredientCreate, 
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user) # Sadece giriş yapanlar ekleyebilir
):
    new_ingredient = InventoryItem(
        name=ingredient.name,
        quantity=ingredient.quantity,
        unit=ingredient.unit,
        owner_id=current_user.id # Token'dan gelen kullanıcının ID'sini basıyoruz
    )
    db.add(new_ingredient)
    await db.commit()
    await db.refresh(new_ingredient)
    return new_ingredient

# 2. Malzemeleri Listeleme (Sadece Benimkiler)
@router.get("/", response_model=List[IngredientOut])
async def read_ingredients(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # Veritabanına: "Sahibi 'ben' olan malzemeleri getir" diyoruz
    result = await db.execute(
        select(InventoryItem).where(InventoryItem.owner_id == current_user.id)
    )
    return result.scalars().all()

# 3. Malzeme Silme
@router.delete("/{ingredient_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_ingredient(
    ingredient_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # Önce malzemeyi bul
    result = await db.execute(
        select(InventoryItem).where(InventoryItem.id == ingredient_id)
    )
    ingredient = result.scalars().first()

    # Malzeme yoksa hata ver
    if not ingredient:
        raise HTTPException(status_code=404, detail="Malzeme bulunamadı")
    
    # Başkasının malzemesini silmeye çalışıyorsa hata ver! 🛡️
    if ingredient.owner_id != current_user.id:
        raise HTTPException(status_code=403, detail="Bu işlem için yetkiniz yok")

    await db.delete(ingredient)
    await db.commit()
