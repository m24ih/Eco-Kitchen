from sqlalchemy import Column, Integer, String, Float, ForeignKey
from sqlalchemy.orm import relationship
from app.core.database import Base

class Ingredient(Base):
    __tablename__ = "ingredients"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True, nullable=False) # Örn: Domates
    quantity = Column(Float, default=1.0)             # Örn: 2.5
    unit = Column(String, default="adet")             # Örn: kg, lt, adet
    
    # Bu malzeme kime ait? (Foreign Key)
    owner_id = Column(Integer, ForeignKey("users.id"))

    # İlişki tanımları (Python tarafında kolay erişim için)
    owner = relationship("User", back_populates="ingredients")