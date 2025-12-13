from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.core.database import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserOut
from app.core.security import get_password_hash

router = APIRouter()

@router.post("/register", response_model=UserOut, status_code=status.HTTP_201_CREATED)
async def register(user: UserCreate, db: AsyncSession = Depends(get_db)):
    # 1. Email kontrolü: Bu email ile kayıtlı biri var mı?
    result = await db.execute(select(User).where(User.email == user.email))
    existing_user = result.scalars().first()
    
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Bu email adresi zaten kullanılıyor."
        )
    
    # 2. Şifreyi hash'le (güvenli hale getir)
    hashed_password = get_password_hash(user.password)
    
    # 3. Yeni kullanıcı nesnesini oluştur
    new_user = User(
        email=user.email,
        password_hash=hashed_password
    )
    
    # 4. Veritabanına ekle ve kaydet
    db.add(new_user)
    await db.commit()
    await db.refresh(new_user) # ID ve Created_at bilgisini geri almak için
    
    return new_user