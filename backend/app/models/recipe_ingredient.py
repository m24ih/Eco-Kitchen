from sqlalchemy import Column, Integer, Float, ForeignKey
from sqlalchemy.orm import relationship
from app.core.database import Base


class RecipeIngredient(Base):
    __tablename__ = "recipe_ingredients"

    id = Column(Integer, primary_key=True, index=True)
    recipe_id = Column(Integer, ForeignKey("recipes.id", ondelete="CASCADE"), nullable=False)
    ingredient_catalog_id = Column(Integer, ForeignKey("ingredient_catalog.id"), nullable=False)
    quantity = Column(Float, nullable=False)

    recipe = relationship("Recipe", back_populates="ingredients")
    ingredient = relationship("IngredientCatalog")
