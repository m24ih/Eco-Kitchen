# 🌿 Eco Kitchen - Backend API

Bu klasör, Eco Kitchen projesinin Python (FastAPI) tabanlı arka uç servislerini içerir.

## ✅ Şu Ana Kadar Neler Yapıldı?

Projenin **Faz 1 (Altyapı & Kimlik Doğrulama)** aşaması tamamlanmıştır:

* [x] **Docker Entegrasyonu:** PostgreSQL veritabanı konteynerize edildi.
* [x] **Veritabanı Bağlantısı:** SQLAlchemy (Async) ile veritabanı bağlantısı kuruldu.
* [x] **Authentication (Auth):**
    * Kullanıcı Kaydı (`/register`) - Şifreler bcrypt ile hashleniyor.
    * Kullanıcı Girişi (`/login`) - JWT (JSON Web Token) üretiliyor.
    * Güvenlik Katmanı - Token doğrulama ve korumalı route yapısı (`/me`).
* [x] **Dokümantasyon:** Swagger UI (`/docs`) otomatik olarak çalışıyor.

---

## 🚀 Kurulum ve Çalıştırma Rehberi

Projeyi kendi bilgisayarında çalıştırmak için aşağıdaki adımları sırasıyla takip et.

### 1. Veritabanını Ayağa Kaldır (Docker)

Veritabanı ayarları ana dizindeki `docker-compose.yml` dosyasındadır. Bir terminal aç ve projenin **ana dizininde** (backend'in bir üstünde) şu komutu çalıştır:

```bash
docker compose up -d
```
Bu işlem PostgreSQL sunucusunu arka planda başlatır.

### 2. Python Ortamını Kur (Backend Klasöründe)
Backend klasörüne gir ve sanal ortamı oluştur:

```Bash
cd backend
python3 -m venv venv
```
Sanal ortamı aktif et:

Mac/Linux: source venv/bin/activate

Windows: venv\Scripts\activate

Kütüphaneleri yükle:

```Bash
pip install -r requirements.txt
```

### 3. Ortam Değişkenlerini Ayarla (.env)
backend klasörünün içinde .env adında bir dosya oluştur ve aşağıdaki ayarları aynen yapıştır (Docker ayarlarıyla uyumludur):

```Ini, TOML
# Veritabanı Ayarları
POSTGRES_USER=melih
POSTGRES_PASSWORD=gizlisifre
POSTGRES_SERVER=localhost
POSTGRES_PORT=5432
POSTGRES_DB=sustain_db

# SQLAlchemy Bağlantı Linki
DATABASE_URL=postgresql+asyncpg://melih:gizlisifre@localhost:5432/sustain_db

# Güvenlik Ayarları
SECRET_KEY=bura_cok_gizli_rastgele_bir_veri_olacak_kimseyle_paylasmayin
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```
### 4. Sunucuyu Başlat 🔥
Her şey hazırsa sunucuyu başlat:

```Bash
uvicorn app.main:app --reload
```
Eğer terminalde Application startup complete yazısını görüyorsan başardın!

🧪 Nasıl Test Edilir?
Tarayıcını aç ve şu adrese git: 👉 http://127.0.0.1:8000/docs

Burada Swagger UI ekranını göreceksin. Test etmek için:

POST /register: Yeni bir kullanıcı oluştur.

POST /login: Oluşturduğun kullanıcı ile giriş yap.

Authorize (Kilit Butonu): Login'den dönen Token'ı buraya girmene gerek yok; Swagger otomatik halleder (Kullanıcı adı/şifre girmen yeterli).

GET /me: Kilit simgesi kapalıyken (giriş yapmışken) bu endpoint'i dene. Kendi bilgilerini görüyorsan sistem çalışıyor demektir.

---

## 🛠 Sırada Ne Var? (To-Do)
Şu anki görevimiz Malzemeler (Ingredients) modülünü yazmak.

app/models/ingredient.py -> SQLAlchemy tablosunu oluştur.

app/schemas/ingredient.py -> Pydantic modellerini (veri giriş/çıkış şemaları) oluştur.

app/api/v1/ingredients.py -> Ekleme, Silme, Listeleme endpointlerini yaz.


---