import os
from pathlib import Path
from pydantic_settings import BaseSettings, SettingsConfigDict

# Projenin kök dizinini bul (app/core/config.py -> app/core -> app -> backend/)
BASE_DIR = Path(__file__).resolve().parent.parent.parent

class Settings(BaseSettings):
    DATABASE_URL: str
    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    GEMINI_API_KEY: str
    
    model_config = SettingsConfigDict(
        # .env dosyasının tam yolunu veriyoruz
        env_file=os.path.join(BASE_DIR, ".env"),
        env_ignore_empty=True,
        extra="ignore"
    )

settings = Settings()