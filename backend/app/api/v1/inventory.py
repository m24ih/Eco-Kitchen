from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import func
from sqlalchemy.future import select
from typing import List

from app.core.database import get_db
from app.api.deps import get_current_user
from app.models.user import User
from app.models.ingredient_catalog import IngredientCatalog
from app.models.inventory_item import InventoryItem
from app.schemas.inventory import InventoryItemCreate, InventoryItemOut

router = APIRouter()

# 1. Stok Ekleme
@router.post("/", response_model=InventoryItemOut, status_code=status.HTTP_201_CREATED)
async def create_inventory_item(
    item: InventoryItemCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    # İsim normalizasyonu (boşlukları sil, küçük harfe çevir)
    normalized_name = item.name.strip().lower()
    if not normalized_name:
        raise HTTPException(status_code=400, detail="Lütfen geçerli bir malzeme adı girin.")

    # Katalog kontrolü (Bu ürün sistemde tanımlı mı?)
    result = await db.execute(
        select(IngredientCatalog).where(
            func.lower(IngredientCatalog.name) == normalized_name
        )
    )
    catalog_item = result.scalars().first()
    
    # Geliştirme Notu: Eğer katalog boşsa veya çok katıysa burası kullanıcıyı üzebilir.
    # Şimdilik katalogda olması zorunlu.
    if not catalog_item:
        raise HTTPException(
            status_code=400, 
            detail=f"'{item.name}' kataloğumuzda bulunamadı. Lütfen listeden seçin."
        )

    # Birim kontrolü
    unit = item.unit.strip() if item.unit else ""
    if not unit:
        unit = catalog_item.default_unit
    elif unit != catalog_item.default_unit:
        # Basitlik adına şimdilik sadece katalogdaki varsayılan birimi kabul ediyoruz
        raise HTTPException(
            status_code=400,
            detail=f"Birim uyuşmazlığı. Beklenen: {catalog_item.default_unit}"
        )

    # Kullanıcının envanterinde bu ürün zaten var mı?
    result = await db.execute(
        select(InventoryItem).where(
            InventoryItem.owner_id == current_user.id,
            InventoryItem.unit == unit,
            func.lower(InventoryItem.name) == normalized_name
        )
    )
    existing_item = result.scalars().first()
    
    # Varsa miktarını artır
    if existing_item:
        existing_item.quantity += item.quantity
        await db.commit()
        await db.refresh(existing_item)
        return existing_item

    # Yoksa yeni oluştur
    new_item = InventoryItem(
        name=normalized_name, # Küçük harfle kaydet
        quantity=item.quantity,
        unit=unit,
        owner_id=current_user.id
    )
    db.add(new_item)
    await db.commit()
    await db.refresh(new_item)
    return new_item

# 2. Stok Listeleme
@router.get("/", response_model=List[InventoryItemOut])
async def read_inventory_items(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    result = await db.execute(
        select(InventoryItem).where(InventoryItem.owner_id == current_user.id)
    )
    return result.scalars().all()

# 3. Stok Silme
@router.delete("/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_inventory_item(
    item_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    result = await db.execute(select(InventoryItem).where(InventoryItem.id == item_id))
    item = result.scalars().first()

    if not item:
        raise HTTPException(status_code=404, detail="Stok bulunamadı")

    if item.owner_id != current_user.id:
        raise HTTPException(status_code=403, detail="Bu işlem için yetkiniz yok")

    await db.delete(item)
    await db.commit()