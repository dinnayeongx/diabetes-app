# Diabetes Detection - Flutter + FastAPI

Project ini menggabungkan:

```txt
Flutter (Dart) sebagai frontend
Python FastAPI sebagai backend
Machine Learning untuk prediksi diabetes
Integrasi API Flutter ↔ FastAPI
```

## Struktur Folder

```txt
diabetes_flutter_fastapi_project/
├── backend/
│   ├── main.py
│   ├── model.pkl
│   ├── requirements.txt
│   └── README.md
│
└── frontend_flutter/
    ├── pubspec.yaml
    └── lib/
        ├── main.dart
        └── screens/
            └── home_screen.dart
```

## Alur Sistem

```txt
User isi data di Flutter
        ↓
Flutter kirim POST request ke FastAPI /predict
        ↓
FastAPI memuat model model.pkl
        ↓
Model ML melakukan prediksi
        ↓
FastAPI mengirim response JSON
        ↓
Flutter menampilkan result dan probability
```

## 1. Menjalankan Backend

```bash
cd backend
```

Jalankan API:

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Cek API:

```txt
http://127.0.0.1:8000/docs
```

## 2. Menjalankan Flutter

```bash
cd frontend
flutter pub get
flutter run
```

## 3. URL API di Flutter

Di `home_screen.dart`, URL otomatis disesuaikan:

```txt
Android Emulator : http://10.0.2.2:8000
Flutter Web      : http://127.0.0.1:8000
Windows/Desktop  : http://127.0.0.1:8000
```

Jika memakai HP fisik, ganti URL menjadi IP laptop, misalnya:

```txt
http://192.168.1.10:8000
```

Lalu jalankan backend dengan:

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## 4. Contoh Request API

```json
{
  "Pregnancies": 2,
  "Glucose": 130,
  "BMI": 32,
  "Age": 38,
  "DiabetesPedigreeFunction": 0.87
}
```

## 5. Contoh Response API

```json
{
  "prediction": 0,
  "result": "Low Diabetes Risk",
  "probability": 41.7,
  "risk_level": "Medium"
}
```