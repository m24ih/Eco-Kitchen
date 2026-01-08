from typing import List
from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.core.database import get_db
from app.models.ingredient_catalog import IngredientCatalog
from app.schemas.catalog import CatalogItemOut

router = APIRouter()


@router.get("/search", response_model=List[CatalogItemOut])
async def search_catalog(
    q: str = Query(..., min_length=1),
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(IngredientCatalog)
        .where(IngredientCatalog.name.ilike(f"{q}%"))
        .limit(10)
    )
    return result.scalars().all()
