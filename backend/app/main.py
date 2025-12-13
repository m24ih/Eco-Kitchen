from contextlib import asynccontextmanager
from fastapi import FastAPI
from app.core.database import engine, Base
from app.models.user import User
# Yeni eklenen import:
from app.api.v1 import auth 

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

@app.get("/")
async def root():
    return {"message": "Eco Kitchen API Çalışıyor! 🌿"}