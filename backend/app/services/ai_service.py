import google.generativeai as genai
from app.core.config import settings
from typing import List

# API Anahtarını yapılandır
genai.configure(api_key=settings.GEMINI_API_KEY)

async def generate_recipe_from_ingredients(ingredients: List[str]) -> str:
    """
    Verilen malzeme listesine göre Gemini'den tarif ister.
    """
    model = genai.GenerativeModel('gemini-3-flash-preview') # Hızlı ve ekonomik model
    
    ingredients_text = ", ".join(ingredients)
    
    prompt = f"""
    Elimde şu malzemeler var: {ingredients_text}.
    
    Lütfen bana bu malzemeleri kullanarak yapabileceğim:
    1. Yaratıcı ve lezzetli bir yemek tarifi ver.
    2. Tarifin adını, gerekli malzemeleri (varsa ekstra temel malzemeler ekleyebilirsin) ve adım adım yapılışını yaz.
    3. Cevabını Türkçe ver ve güzel, okunaklı bir formatta olsun.
    """
    
    try:
        # Senkron çalışan kütüphaneyi async fonksiyon içinde çağırıyoruz
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        return f"Üzgünüm, şu an tarif üretemiyorum. Hata: {str(e)}"
