from contextlib import asynccontextmanager
from fastapi import FastAPI
from app.core.database import engine, Base
from app.api.v1 import auth
from app.api.v1 import recipes
from app.api.v1 import catalog
from app.api.v1 import inventory
from app.api.v1 import shopping_list
from app.api.v1 import favorites

@asynccontextmanager
async def lifespan(app: FastAPI):
    print("🚀 Veritabanı tabloları kontrol ediliyor...")
    async with engine.begin() as conn:
        # Tablolar yoksa oluşturur (Migration aracı kullanılmadığında hayat kurtarır)
        await conn.run_sync(Base.metadata.create_all)
    print("✅ Sistem hazır!")
    yield
    print("🛑 Sistem kapanıyor...")

app = FastAPI(
    title="Eco Kitchen API",
    description="Sürdürülebilir Mutfak ve Yapay Zeka Destekli Tarif Uygulaması",
    version="1.0.0",
    lifespan=lifespan
)

# Router'ları ekle
app.include_router(auth.router, prefix="/api/v1/auth", tags=["Auth"])
app.include_router(recipes.router, prefix="/api/v1/recipes", tags=["Recipes"])
app.include_router(inventory.router, prefix="/api/v1/inventory", tags=["Inventory"]) # Stok Yönetimi
app.include_router(catalog.router, prefix="/api/v1/catalog", tags=["Catalog"])
app.include_router(shopping_list.router, prefix="/api/v1/shopping-list", tags=["Shopping List"])
app.include_router(favorites.router, prefix="/api/v1/favorites", tags=["Favorites"])

@app.get("/")
async def root():
    return {"message": "Welcome to Eco Kitchen API"}