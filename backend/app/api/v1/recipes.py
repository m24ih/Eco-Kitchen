from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.core.database import get_db
from app.api.deps import get_current_user
from app.models.user import User
from app.models.inventory_item import InventoryItem
from app.services.ai_service import generate_recipe_from_ingredients

router = APIRouter()

@router.post("/generate")
async def suggest_recipe(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # 1. Kullanıcının malzemelerini çek
    result = await db.execute(
        select(InventoryItem).where(InventoryItem.owner_id == current_user.id)
    )
    ingredients = result.scalars().all()
    
    if not ingredients:
        raise HTTPException(status_code=400, detail="Dolabınız boş! Önce malzeme ekleyin.")
    
    # 2. Sadece malzeme isimlerini listeye çevir (Örn: ["Yumurta", "Süt"])
    ingredient_names = [i.name for i in ingredients]
    
    # 3. AI Servisine gönder
    recipe_text = await generate_recipe_from_ingredients(ingredient_names)
    
    # 4. Sonucu döndür
    return {"recipe": recipe_text}
