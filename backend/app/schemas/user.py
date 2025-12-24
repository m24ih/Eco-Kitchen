from pydantic import BaseModel, EmailStr, ConfigDict
from datetime import datetime

# Temel sınıf (Ortak alanlar)
class UserBase(BaseModel):
    email: EmailStr

# Kayıt olurken istenecek veriler (Şifre şart!)
class UserCreate(UserBase):
    password: str

# Kullanıcıya geri döndüreceğimiz veriler (Şifreyi gizliyoruz!)
class UserOut(UserBase):
    id: int
    is_active: bool
    created_at: datetime

    # ORM nesnesini (SQLAlchemy modelini) Pydantic modeline çevirmek için gerekli ayar
    model_config = ConfigDict(from_attributes=True)


# Login için sadece email ve şifre yeterli
class UserLogin(BaseModel):
    email: EmailStr
    password: str