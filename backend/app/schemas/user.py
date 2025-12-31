from pydantic import BaseModel, EmailStr, ConfigDict
from datetime import datetime
from typing import Optional

# Temel sınıf (Ortak alanlar)
class UserBase(BaseModel):
    email: EmailStr

# Kayıt olurken istenecek veriler (Şifre şart!)
class UserCreate(BaseModel):
    email: EmailStr
    password: str
    # Yeni eklenenler:
    height: Optional[int] = None
    weight: Optional[int] = None
    activity_level: Optional[float] = None
    goal: Optional[str] = None
    birth_date: Optional[datetime] = None

# Kullanıcıya geri döndüreceğimiz veriler (Şifreyi gizliyoruz!)
class UserOut(BaseModel):
    id: int
    email: EmailStr
    is_active: bool
    # Yeni eklenenler:
    height: Optional[int] = None
    weight: Optional[int] = None

    # ORM nesnesini (SQLAlchemy modelini) Pydantic modeline çevirmek için gerekli ayar
    model_config = ConfigDict(from_attributes=True)

class Config:
        from_attributes = True

# Login için sadece email ve şifre yeterli
class UserLogin(BaseModel):
    email: EmailStr
    password: str