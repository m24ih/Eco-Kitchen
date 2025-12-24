from pydantic import BaseModel

# Kullanıcıya dönecek olan Token verisi
class Token(BaseModel):
    access_token: str
    token_type: str

# Token'ın içindeki veriyi okurken kullanacağımız yapı
class TokenData(BaseModel):
    email: str | None = None