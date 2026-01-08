# Run: python -m app.seed_catalog
import asyncio
from typing import List, Dict

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import SessionLocal
from app.models.ingredient_catalog import IngredientCatalog


SEED_ITEMS: List[Dict[str, str]] = [
    {"name": "water", "default_unit": "ml", "aliases": "su"},
    {"name": "milk", "default_unit": "ml", "aliases": "sut, tam yagli sut"},
    {"name": "yogurt", "default_unit": "g", "aliases": "yogurt, yoğurt"},
    {"name": "butter", "default_unit": "g", "aliases": "tereyagi, tereyağı"},
    {"name": "olive oil", "default_unit": "ml", "aliases": "zeytinyagi, zeytinyağı"},
    {"name": "sunflower oil", "default_unit": "ml", "aliases": "aycicek yagi, ayçiçek yağı"},
    {"name": "egg", "default_unit": "piece", "aliases": "yumurta"},
    {"name": "flour", "default_unit": "g", "aliases": "un"},
    {"name": "sugar", "default_unit": "g", "aliases": "seker, şeker"},
    {"name": "salt", "default_unit": "g", "aliases": "tuz"},
    {"name": "black pepper", "default_unit": "g", "aliases": "karabiber"},
    {"name": "red pepper flakes", "default_unit": "g", "aliases": "pul biber"},
    {"name": "paprika", "default_unit": "g", "aliases": "toz biber"},
    {"name": "cumin", "default_unit": "g", "aliases": "kimyon"},
    {"name": "cinnamon", "default_unit": "g", "aliases": "tarcin, tarçın"},
    {"name": "vanilla", "default_unit": "g", "aliases": "vanilya"},
    {"name": "baking powder", "default_unit": "g", "aliases": "kabartma tozu"},
    {"name": "baking soda", "default_unit": "g", "aliases": "karbonat"},
    {"name": "yeast", "default_unit": "g", "aliases": "maya"},
    {"name": "tomato", "default_unit": "piece", "aliases": "domates"},
    {"name": "onion", "default_unit": "piece", "aliases": "sogan, soğan"},
    {"name": "garlic", "default_unit": "piece", "aliases": "sarmisak, sarımsak"},
    {"name": "potato", "default_unit": "piece", "aliases": "patates"},
    {"name": "carrot", "default_unit": "piece", "aliases": "havuc, havuç"},
    {"name": "cucumber", "default_unit": "piece", "aliases": "salatalik, salatalık"},
    {"name": "green pepper", "default_unit": "piece", "aliases": "yesil biber, yeşil biber"},
    {"name": "red pepper", "default_unit": "piece", "aliases": "kirmizi biber, kırmızı biber"},
    {"name": "eggplant", "default_unit": "piece", "aliases": "patlican, patlıcan"},
    {"name": "zucchini", "default_unit": "piece", "aliases": "kabak"},
    {"name": "mushroom", "default_unit": "g", "aliases": "mantar"},
    {"name": "lettuce", "default_unit": "piece", "aliases": "marul"},
    {"name": "parsley", "default_unit": "g", "aliases": "maydanoz"},
    {"name": "dill", "default_unit": "g", "aliases": "dereotu"},
    {"name": "mint", "default_unit": "g", "aliases": "nane"},
    {"name": "lemon", "default_unit": "piece", "aliases": "limon"},
    {"name": "lime", "default_unit": "piece", "aliases": "misket limon"},
    {"name": "orange", "default_unit": "piece", "aliases": "portakal"},
    {"name": "apple", "default_unit": "piece", "aliases": "elma"},
    {"name": "banana", "default_unit": "piece", "aliases": "muz"},
    {"name": "strawberry", "default_unit": "g", "aliases": "cilek, çilek"},
    {"name": "rice", "default_unit": "g", "aliases": "pirinc, pirinç"},
    {"name": "bulgur", "default_unit": "g", "aliases": "bulgur"},
    {"name": "pasta", "default_unit": "g", "aliases": "makarna"},
    {"name": "chicken breast", "default_unit": "g", "aliases": "tavuk gogsu, tavuk göğsü"},
    {"name": "chicken thigh", "default_unit": "g", "aliases": "tavuk but"},
    {"name": "beef", "default_unit": "g", "aliases": "dana eti"},
    {"name": "ground beef", "default_unit": "g", "aliases": "kıyma, kiyma"},
    {"name": "fish", "default_unit": "g", "aliases": "balik, balık"},
    {"name": "lentils", "default_unit": "g", "aliases": "mercimek"},
    {"name": "chickpeas", "default_unit": "g", "aliases": "nohut"},
    {"name": "beans", "default_unit": "g", "aliases": "kuru fasulye"},
    {"name": "cheese", "default_unit": "g", "aliases": "peynir"},
    {"name": "feta cheese", "default_unit": "g", "aliases": "beyaz peynir"},
    {"name": "cream", "default_unit": "ml", "aliases": "krem"},
    {"name": "tomato paste", "default_unit": "g", "aliases": "salca, salça"},
    {"name": "vinegar", "default_unit": "ml", "aliases": "sirke"},
    {"name": "soy sauce", "default_unit": "ml", "aliases": "soya sosu"},
    {"name": "honey", "default_unit": "g", "aliases": "bal"},
    {"name": "molasses", "default_unit": "g", "aliases": "pekmez"},
    {"name": "walnut", "default_unit": "g", "aliases": "ceviz"},
    {"name": "hazelnut", "default_unit": "g", "aliases": "findik, fındık"},
    {"name": "almond", "default_unit": "g", "aliases": "badem"},
    {"name": "breadcrumbs", "default_unit": "g", "aliases": "galeta unu"},
    {"name": "corn", "default_unit": "g", "aliases": "misir, mısır"},
    {"name": "peas", "default_unit": "g", "aliases": "bezelye"},
    {"name": "spinach", "default_unit": "g", "aliases": "ispanak"},
    {"name": "cauliflower", "default_unit": "piece", "aliases": "karnabahar"},
    {"name": "broccoli", "default_unit": "piece", "aliases": "brokoli"},
    {"name": "ketchup", "default_unit": "ml", "aliases": "ketcap, ketçap"},
    {"name": "mayonnaise", "default_unit": "ml", "aliases": "mayonez"},
    {"name": "mustard", "default_unit": "ml", "aliases": "hardal"},
    {"name": "bay leaf", "default_unit": "piece", "aliases": "defne yapragi, defne yaprağı"},
    {"name": "thyme", "default_unit": "g", "aliases": "kekik"},
    {"name": "oregano", "default_unit": "g", "aliases": "kekik"},
    {"name": "rosemary", "default_unit": "g", "aliases": "biberiye"},
    {"name": "ginger", "default_unit": "g", "aliases": "zencefil"},
    {"name": "turmeric", "default_unit": "g", "aliases": "zerdecal, zerdeçal"},
    {"name": "cocoa", "default_unit": "g", "aliases": "kakao"},
    {"name": "chocolate", "default_unit": "g", "aliases": "cikolata, çikolata"},
    {"name": "jam", "default_unit": "g", "aliases": "recel, reçel"},
]


async def seed_catalog(session: AsyncSession) -> int:
    names = [item["name"] for item in SEED_ITEMS]
    result = await session.execute(
        select(IngredientCatalog.name).where(IngredientCatalog.name.in_(names))
    )
    existing = {row[0] for row in result.all()}

    to_add = [
        IngredientCatalog(**item)
        for item in SEED_ITEMS
        if item["name"] not in existing
    ]

    if not to_add:
        return 0

    session.add_all(to_add)
    await session.commit()
    return len(to_add)


async def main() -> None:
    async with SessionLocal() as session:
        count = await seed_catalog(session)
        print(f"Seeded {count} catalog items.")


if __name__ == "__main__":
    asyncio.run(main())
