from contextlib import asynccontextmanager
from fastapi import FastAPI
from app.core.database import engine, Base
# Modelleri import etmeliyiz ki SQLAlchemy onları tanısın ve tablo oluştursun
from app.models.user import User 

# Lifespan: Uygulama açılırken çalışacak kodlar
@asynccontextmanager
async def lifespan(app: FastAPI):
    print("🚀 Veritabanı tabloları oluşturuluyor...")
    async with engine.begin() as conn:
        # Tüm tabloları veritabanında oluştur
        await conn.run_sync(Base.metadata.create_all)
    print("✅ Tablolar oluşturuldu!")
    yield
    print("🛑 Sistem kapanıyor...")

app = FastAPI(title="Eco Kitchen API", lifespan=lifespan)

@app.get("/")
async def root():
    return {"message": "Eco Kitchen API Çalışıyor! 🌿"}