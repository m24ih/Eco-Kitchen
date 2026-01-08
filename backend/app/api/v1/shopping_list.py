from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import func
from sqlalchemy.future import select

from app.core.database import get_db
from app.api.deps import get_current_user
from app.models.user import User
from app.models.ingredient_catalog import IngredientCatalog
from app.models.inventory_item import InventoryItem
from app.models.shopping_list_item import ShoppingListItem
from app.schemas.inventory import InventoryItemOut
from app.schemas.shopping_list import (
    ShoppingListItemCreate,
    ShoppingListItemOut,
    ShoppingListItemUpdate,
)

router = APIRouter()


@router.post("/", response_model=ShoppingListItemOut, status_code=status.HTTP_201_CREATED)
async def create_shopping_list_item(
    item: ShoppingListItemCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    normalized_name = item.name.strip().lower()
    if not normalized_name:
        raise HTTPException(status_code=400, detail="Item not found in catalog. Please choose from catalog.")

    result = await db.execute(
        select(IngredientCatalog).where(
            func.lower(IngredientCatalog.name) == normalized_name
        )
    )
    catalog_item = result.scalars().first()
    if not catalog_item:
        raise HTTPException(status_code=400, detail="Item not found in catalog. Please choose from catalog.")

    unit = item.unit.strip() if item.unit else ""
    if not unit:
        unit = catalog_item.default_unit
    elif unit != catalog_item.default_unit:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid unit for this item. Expected: {catalog_item.default_unit}"
        )

    result = await db.execute(
        select(ShoppingListItem).where(
            ShoppingListItem.owner_id == current_user.id,
            ShoppingListItem.unit == unit,
            func.lower(ShoppingListItem.name) == normalized_name
        )
    )
    existing_item = result.scalars().first()
    if existing_item:
        existing_item.quantity += item.quantity
        await db.commit()
        await db.refresh(existing_item)
        return existing_item

    new_item = ShoppingListItem(
        name=normalized_name,
        quantity=item.quantity,
        unit=unit,
        owner_id=current_user.id
    )
    db.add(new_item)
    await db.commit()
    await db.refresh(new_item)
    return new_item


@router.get("/", response_model=List[ShoppingListItemOut])
async def read_shopping_list_items(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    result = await db.execute(
        select(ShoppingListItem).where(ShoppingListItem.owner_id == current_user.id)
    )
    return result.scalars().all()


@router.patch("/{item_id}", response_model=ShoppingListItemOut)
async def update_shopping_list_item(
    item_id: int,
    item: ShoppingListItemUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    result = await db.execute(
        select(ShoppingListItem).where(ShoppingListItem.id == item_id)
    )
    shopping_item = result.scalars().first()

    if not shopping_item:
        raise HTTPException(status_code=404, detail="Alisveris listesi oge bulunamadi")

    if shopping_item.owner_id != current_user.id:
        raise HTTPException(status_code=403, detail="Bu islem icin yetkiniz yok")

    if item.quantity is not None:
        shopping_item.quantity = item.quantity
    if item.unit is not None:
        normalized_name = shopping_item.name.strip().lower()
        if not normalized_name:
            raise HTTPException(status_code=400, detail="Item not found in catalog. Please choose from catalog.")

        result = await db.execute(
            select(IngredientCatalog).where(
                func.lower(IngredientCatalog.name) == normalized_name
            )
        )
        catalog_item = result.scalars().first()
        if not catalog_item:
            raise HTTPException(status_code=400, detail="Item not found in catalog. Please choose from catalog.")

        unit = item.unit.strip()
        if unit != catalog_item.default_unit:
            raise HTTPException(
                status_code=400,
                detail=f"Invalid unit for this item. Expected: {catalog_item.default_unit}"
            )
        shopping_item.unit = unit
    if item.is_checked is not None:
        shopping_item.is_checked = item.is_checked

    await db.commit()
    await db.refresh(shopping_item)
    return shopping_item


@router.delete("/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_shopping_list_item(
    item_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    result = await db.execute(
        select(ShoppingListItem).where(ShoppingListItem.id == item_id)
    )
    shopping_item = result.scalars().first()

    if not shopping_item:
        raise HTTPException(status_code=404, detail="Alisveris listesi oge bulunamadi")

    if shopping_item.owner_id != current_user.id:
        raise HTTPException(status_code=403, detail="Bu islem icin yetkiniz yok")

    await db.delete(shopping_item)
    await db.commit()


@router.post("/{item_id}/transfer-to-inventory", response_model=InventoryItemOut)
async def transfer_to_inventory(
    item_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    result = await db.execute(
        select(ShoppingListItem).where(ShoppingListItem.id == item_id)
    )
    shopping_item = result.scalars().first()

    if not shopping_item:
        raise HTTPException(status_code=404, detail="Alisveris listesi oge bulunamadi")

    if shopping_item.owner_id != current_user.id:
        raise HTTPException(status_code=403, detail="Bu islem icin yetkiniz yok")

    normalized_name = shopping_item.name.strip().lower()
    if not normalized_name:
        raise HTTPException(status_code=400, detail="Item not found in catalog. Please choose from catalog.")

    result = await db.execute(
        select(IngredientCatalog).where(
            func.lower(IngredientCatalog.name) == normalized_name
        )
    )
    catalog_item = result.scalars().first()
    if not catalog_item:
        raise HTTPException(status_code=400, detail="Item not found in catalog. Please choose from catalog.")

    unit = shopping_item.unit.strip() if shopping_item.unit else ""
    if unit != catalog_item.default_unit:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid unit for this item. Expected: {catalog_item.default_unit}"
        )

    result = await db.execute(
        select(InventoryItem).where(
            InventoryItem.owner_id == current_user.id,
            InventoryItem.unit == unit,
            func.lower(InventoryItem.name) == normalized_name
        )
    )
    inventory_item = result.scalars().first()
    if inventory_item:
        inventory_item.quantity += shopping_item.quantity
    else:
        inventory_item = InventoryItem(
            name=normalized_name,
            quantity=shopping_item.quantity,
            unit=unit,
            owner_id=current_user.id
        )
        db.add(inventory_item)

    await db.delete(shopping_item)
    await db.commit()
    await db.refresh(inventory_item)
    return inventory_item
