from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.sql import func
from app.core.database import Base


class IngredientCatalog(Base):
    __tablename__ = "ingredient_catalog"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True, nullable=False)
    default_unit = Column(String, nullable=False)
    aliases = Column(String, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
