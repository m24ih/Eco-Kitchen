import google.generativeai as genai
from app.core.config import settings
from typing import List

# API Anahtarını yapılandır
genai.configure(api_key=settings.GEMINI_API_KEY)

async def generate_recipe_from_ingredients(ingredients: List[str]) -> str:
    """
    Verilen malzeme listesine göre Gemini'den asenkron olarak tarif ister.
    """
    model = genai.GenerativeModel('gemini-3-flash-preview')
    
    ingredients_text = ", ".join(ingredients)
    
    prompt = f"""
    Sen profesyonel, sürdürülebilirliğe önem veren bir "Eco Kitchen" yapay zeka şefisin.
    Elimde şu malzemeler var: {ingredients_text}.
    
    Lütfen bu malzemeleri (ve evde bulunabilecek temel malzemeleri: yağ, tuz, karabiber, su vb.) kullanarak:
    1. İSRAF ETMEDEN yapabileceğim yaratıcı ve lezzetli bir yemek tarifi oluştur.
    2. Tarifin ismini en başa kalın bir başlık olarak yaz.
    3. Gerekli malzemeler listesini madde madde yaz.
    4. Hazırlanış adımlarını net bir şekilde numaralandırarak anlat.
    5. En sona bu yemekle veya malzemelerle ilgili kısa bir "Sıfır Atık İpucu" (Zero Waste Tip) ekle.
    
    Cevabını Türkçe ver ve güzel, okunaklı bir Markdown formatında olsun.
    """
    
    try:
        # Asenkron metod kullanarak sunucunun kilitlenmesini önlüyoruz
        response = await model.generate_content_async(prompt)
        return response.text
    except Exception as e:
        print(f"AI Service Error: {e}")
        return "Üzgünüm, şu an şefimiz biraz yoğun. Lütfen internet bağlantınızı kontrol edip tekrar deneyin."
