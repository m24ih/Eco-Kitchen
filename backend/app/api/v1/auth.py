from app.api.deps import get_current_user
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
from fastapi.security import OAuth2PasswordRequestForm

router = APIRouter()

@router.post("/register", response_model=UserOut, status_code=status.HTTP_201_CREATED)
async def register(user: UserCreate, db: AsyncSession = Depends(get_db)):
    # ... (Email kontrolü aynı kalacak) ...
    
    hashed_password = get_password_hash(user.password)
    
    # Yeni alanları da ekleyerek oluştur
    new_user = User(
        email=user.email,
        password_hash=hashed_password,
        height=user.height,
        weight=user.weight,
        activity_level=user.activity_level,
        goal=user.goal,
        birth_date=user.birth_date
    )
    
    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)
    return new_user


@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(get_db)):
    # Swagger UI 'username' ve 'password' gönderir.
    # Biz 'username' alanına email yazacağız.
    
    # 1. Kullanıcıyı veritabanında ara (form_data.username içinde email gelecek)
    result = await db.execute(select(User).where(User.email == form_data.username))
    user = result.scalars().first()

    # 2. Kullanıcı yoksa veya şifre yanlışsa
    if not user or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Hatalı email veya şifre",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # 3. Giriş başarılı, Token üret
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.email},
        expires_delta=access_token_expires
    )
    
    return {"access_token": access_token, "token_type": "bearer"}

@router.get("/me", response_model=UserOut)
async def read_users_me(current_user: User = Depends(get_current_user)):
    """
    Sadece giriş yapmış kullanıcının görebileceği profil bilgisi.
    Token geçerliyse 'current_user' otomatik olarak dolar.
    """
    return current_user