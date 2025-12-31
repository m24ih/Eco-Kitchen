from sqlalchemy import Column, Integer, String, Boolean, DateTime, Float, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    # Yeni Sütunlar
    height = Column(Integer, nullable=True)
    weight = Column(Integer, nullable=True)
    activity_level = Column(Float, nullable=True)
    goal = Column(String, nullable=True)
    birth_date = Column(DateTime(timezone=True), nullable=True)
    
    # İlişkiler
    ingredients = relationship("Ingredient", back_populates="owner")