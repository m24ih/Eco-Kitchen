from contextlib import asynccontextmanager
from fastapi import FastAPI
from app.core.database import engine, Base
from app.models.user import User
from app.api.v1 import auth 
from app.api.v1 import ingredients
from app.models.inventory_item import InventoryItem
from app.api.v1 import recipes
from app.api.v1 import catalog
from app.api.v1 import inventory
from app.api.v1 import shopping_list


@asynccontextmanager
async def lifespan(app: FastAPI):
    print("🚀 Veritabanı tabloları oluşturuluyor...")
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    print("✅ Tablolar oluşturuldu!")
    yield
    print("🛑 Sistem kapanıyor...")

app = FastAPI(title="Eco Kitchen API", lifespan=lifespan)

# Router'ı dahil etme işlemi:
app.include_router(auth.router, prefix="/api/v1/auth", tags=["Kimlik Doğrulama"])
app.include_router(recipes.router, prefix="/api/v1/recipes", tags=["Tarifler"])
app.include_router(inventory.router, prefix="/api/v1/inventory", tags=["inventory"])
app.include_router(catalog.router, prefix="/api/v1/catalog", tags=["catalog"])
app.include_router(shopping_list.router, prefix="/api/v1/shopping-list", tags=["shopping-list"])

@app.get("/")
async def root():
    return {"message": "Eco Kitchen API Çalışıyor! 🌿"}
