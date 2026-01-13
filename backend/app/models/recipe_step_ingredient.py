from sqlalchemy import Column, Integer, String, ForeignKey, UniqueConstraint
from sqlalchemy.orm import relationship
from app.core.database import Base


class RecipeStepIngredient(Base):
    __tablename__ = "recipe_step_ingredients"
    __table_args__ = (
        UniqueConstraint("step_id", "ingredient_catalog_id", name="uq_step_ingredient"),
    )

    id = Column(Integer, primary_key=True, index=True)
    step_id = Column(Integer, ForeignKey("recipe_steps.id", ondelete="CASCADE"), nullable=False)
    ingredient_catalog_id = Column(Integer, ForeignKey("ingredient_catalog.id"), nullable=False)
    amount_text = Column(String, nullable=False)
    note = Column(String, nullable=True)

    step = relationship("RecipeStep", back_populates="ingredients")
    ingredient = relationship("IngredientCatalog")
