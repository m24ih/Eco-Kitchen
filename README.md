# Eco-Kitchen
Sustainable AI Recipe Application

# 🌿 Eco Kitchen

Eco Kitchen, evdeki atık gıdaları değerlendirerek israfı önlemeyi amaçlayan, yapay zeka destekli cross-platform bir mobil uygulamadır. Kullanıcıların elindeki malzemelere göre hem kendileri hem de evcil hayvanları için sağlıklı tarifler üretir.

## 🚀 Özellikler

- **AI Tarif Üretici:** Google Gemini AI kullanarak eldeki malzemelerle yaratıcı tarifler oluşturma.
- **Sürdürülebilirlik:** Gıda israfını azaltmaya yönelik akıllı öneriler.
- **Cross-Platform:** Flutter sayesinde hem iOS hem de Android'de çalışır.

## 🛠 Teknoloji Yığını (Tech Stack)

| Alan | Teknoloji | Detaylar |
|---|---|---|
| **Mobil (Frontend)** | Flutter | Dart, Riverpod (State Mgt), Dio |
| **Backend** | Python (FastAPI) | Async SQLAlchemy, Pydantic |
| **Veritabanı** | PostgreSQL | Docker üzerinde çalışır |
| **Yapay Zeka** | Google Gemini | Flash-Lite / Flash Modelleri |
| **Altyapı** | Docker | Docker Compose, Nginx |

## 📂 Proje Yapısı

Bu proje bir **Monorepo** yapısındadır:

```text
Eco-Kitchen/
├── backend/            # FastAPI, Veritabanı Modelleri ve AI Servisleri
├── mobile/             # Flutter Mobil Uygulaması
└── docker-compose.yml  # Veritabanı ve servis orkestrasyonu
````

## ⚙️ Kurulum ve Çalıştırma

Projeyi yerel ortamınızda çalıştırmak için aşağıdaki adımları takip edin.

### 1\. Ön Gereksinimler

  - Git
  - Docker & Docker Compose
  - Python 3.10+
  - Flutter SDK

### 2\. Projeyi Klonlayın

```bash
git clone [https://github.com/kullaniciadi/eco-kitchen.git](https://github.com/m24ih/Eco-Kitchen.git)
cd Eco-Kitchen
```

### 3\. Backend Kurulumu

Önce veritabanını ayağa kaldırın:

```bash
docker compose up -d
```

Backend klasörüne gidin ve sanal ortamı kurun:

```bash
cd backend
python3 -m venv venv
source venv/bin/activate  # Windows için: venv\Scripts\activate
pip install -r requirements.txt
```

`.env` dosyasını oluşturun:
`backend/.env` dosyası oluşturup içine şunları ekleyin:

```ini
POSTGRES_USER=melih
POSTGRES_PASSWORD=gizlisifre
POSTGRES_SERVER=localhost
POSTGRES_PORT=5432
POSTGRES_DB=sustain_db
DATABASE_URL=postgresql+asyncpg://melih:gizlisifre@localhost:5432/sustain_db
SECRET_KEY=gizli_anahtar_buraya
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
GEMINI_API_KEY=google_ai_key_buraya
```

Sunucuyu başlatın:

```bash
uvicorn app.main:app --reload
```

*Backend şu adreste çalışacak: `http://127.0.0.1:8000`*
*API Dokümantasyonu (Swagger): `http://127.0.0.1:8000/docs`*

### 4\. Mobile (Flutter) Kurulumu

Yeni bir terminal açın ve mobil klasörüne gidin:

```bash
cd mobile
flutter pub get
flutter run
```

## 🤝 Katkıda Bulunma

1.  Bu repoyu "Fork"layın.
2.  Yeni bir "feature branch" oluşturun (`git checkout -b feature/yeni-ozellik`).
3.  Değişikliklerinizi "Commit"leyin (`git commit -m 'feat: Yeni özellik eklendi'`).
4.  Branch'inizi "Push"layın (`git push origin feature/yeni-ozellik`).
5.  Bir "Pull Request" (PR) oluşturun.

