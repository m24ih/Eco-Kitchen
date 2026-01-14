from pydantic import BaseModel, EmailStr, ConfigDict
from datetime import datetime
from typing import Optional

# Temel sınıf (Ortak alanlar)
class UserBase(BaseModel):
    email: EmailStr

# Kayıt olurken istenecek veriler
class UserCreate(BaseModel):
    email: EmailStr
    password: str
    full_name: Optional[str] = None
    height: Optional[int] = None
    weight: Optional[int] = None
    activity_level: Optional[float] = None
    goal: Optional[str] = None
    birth_date: Optional[datetime] = None

# Kullanıcıya geri döndüreceğimiz veriler (Response)
class UserOut(BaseModel):
    id: int
    email: EmailStr
    is_active: bool
    full_name: Optional[str] = None
    
    # Profil Detayları
    height: Optional[int] = None
    weight: Optional[int] = None
    activity_level: Optional[float] = None # EKLENDİ
    goal: Optional[str] = None           # EKLENDİ
    birth_date: Optional[datetime] = None # EKLENDİ

    model_config = ConfigDict(from_attributes=True)

# Login için şema
class UserLogin(BaseModel):
    email: EmailStr
    password: str