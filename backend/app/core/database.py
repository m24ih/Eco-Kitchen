from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy.orm import DeclarativeBase
from app.core.config import settings

# Veritabanı Motorunu Oluştur (Async)
engine = create_async_engine(settings.DATABASE_URL, echo=True) # echo=True: SQL sorgularını terminale yazar

# Oturum Oluşturucu (Session Factory)
SessionLocal = async_sessionmaker(autocommit=False, autoflush=False, bind=engine, class_=AsyncSession)

# Tüm modellerin miras alacağı Temel Sınıf
class Base(DeclarativeBase):
    pass

# Dependency (Bağımlılık): Her istekte DB oturumu açar ve iş bitince kapatır
async def get_db():
    async with SessionLocal() as session:
        yield session