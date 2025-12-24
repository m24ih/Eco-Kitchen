from datetime import timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.core.database import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserOut, UserLogin # UserLogin eklendi
from app.schemas.token import Token # Token eklendi
from app.core.security import get_password_hash, verify_password, create_access_token # Fonksiyonlar eklendi
from app.core.config import settings

router = APIRouter()

# ... (Mevcut register fonksiyonu burada kalacak) ...

@router.post("/login", response_model=Token)
async def login(user_credentials: UserLogin, db: AsyncSession = Depends(get_db)):
    # 1. Kullanıcıyı veritabanında ara
    result = await db.execute(select(User).where(User.email == user_credentials.email))
    user = result.scalars().first()

    # 2. Kullanıcı yoksa VEYA şifre yanlışsa hata ver
    # (Güvenlik için "Kullanıcı bulunamadı" demek yerine genel hata veriyoruz)
    if not user or not verify_password(user_credentials.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Hatalı email veya şifre",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # 3. Giriş başarılı, Token üret
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.email}, # Token'ın içine email'i gömüyoruz
        expires_delta=access_token_expires
    )
    
    # 4. Token'ı döndür
    return {"access_token": access_token, "token_type": "bearer"}