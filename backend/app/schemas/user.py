from pydantic import BaseModel, EmailStr, ConfigDict, field_validator
from datetime import datetime
from typing import Optional

# Temel sınıf (Ortak alanlar)
class UserBase(BaseModel):
    email: EmailStr

# Kayıt olurken istenecek veriler (Şifre şart!)
class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str
    # Yeni eklenenler:
    height: Optional[int] = None
    weight: Optional[int] = None
    activity_level: Optional[float] = None
    goal: Optional[str] = None
    birth_date: Optional[datetime] = None

    @field_validator("password")
    @classmethod
    def validate_password(cls, value: str) -> str:
        if len(value) < 8:
            raise ValueError("Password must be at least 8 characters long.")
        if not any(char.isdigit() for char in value):
            raise ValueError("Password must include at least one digit.")
        if not any(char.islower() for char in value):
            raise ValueError("Password must include at least one lowercase letter.")
        if not any(char.isupper() for char in value):
            raise ValueError("Password must include at least one uppercase letter.")
        return value

    @field_validator("name")
    @classmethod
    def normalize_name(cls, value: str) -> str:
        trimmed = value.strip()
        if not trimmed:
            raise ValueError("Name is required.")
        collapsed = " ".join(trimmed.split())
        return collapsed.title()

# Kullanıcıya geri döndüreceğimiz veriler (Şifreyi gizliyoruz!)
class UserOut(BaseModel):
    id: int
    email: EmailStr
    name: Optional[str] = None
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
