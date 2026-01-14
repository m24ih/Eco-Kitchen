from app.api.deps import get_current_user
from datetime import timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.exc import IntegrityError # Hata yakalamak için
from app.core.database import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserOut
from app.schemas.token import Token
from app.core.security import get_password_hash, verify_password, create_access_token
from app.core.config import settings
from fastapi.security import OAuth2PasswordRequestForm

router = APIRouter()

@router.post("/register", response_model=UserOut, status_code=status.HTTP_201_CREATED)
async def register(user: UserCreate, db: AsyncSession = Depends(get_db)):
    # 1. Önce bu email var mı kontrol et
    result = await db.execute(select(User).where(User.email == user.email))
    existing_user = result.scalars().first()
    
    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="Bu email adresi ile zaten bir kayıt mevcut."
        )

    # 2. Şifreyi hashle ve kullanıcıyı hazırla
    hashed_password = get_password_hash(user.password)
    new_user = User(
        email=user.email,
        password_hash=hashed_password,
        full_name=user.full_name,
        height=user.height,
        weight=user.weight,
        activity_level=user.activity_level,
        goal=user.goal,
        birth_date=user.birth_date
    )
    
    try:
        # 3. Veritabanına kaydet
        db.add(new_user)
        await db.commit()
        await db.refresh(new_user)
        return new_user
    except IntegrityError:
        await db.rollback()
        raise HTTPException(
            status_code=400,
            detail="Kayıt oluşturulurken bir hata oluştu (Muhtemelen email çakışması)."
        )
    except Exception as e:
        await db.rollback()
        print(f"Register Error: {e}") # Backend terminalinde hatayı görmek için
        raise HTTPException(
            status_code=500,
            detail=f"Sunucu hatası: {str(e)}"
        )

@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(get_db)):
    # 1. Kullanıcıyı bul
    result = await db.execute(select(User).where(User.email == form_data.username))
    user = result.scalars().first()

    # 2. Şifre kontrolü
    if not user or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Hatalı email veya şifre",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # 3. Token oluştur
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.email},
        expires_delta=access_token_expires
    )
    
    return {"access_token": access_token, "token_type": "bearer"}

@router.get("/me", response_model=UserOut)
async def read_users_me(current_user: User = Depends(get_current_user)):
    return current_user