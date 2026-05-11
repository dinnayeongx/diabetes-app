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
│   ├── train_model.py
│   ├── requirements.txt
│   ├── sample_request.json
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
FastAPI memuat model diabetes_model.pkl
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
pip install -r requirements.txt
```

Letakkan dataset `diabetes.csv` di folder `backend`.

Kemudian training model:

```bash
python train_model.py
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
cd frontend_flutter
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
  "Glucose": 120,
  "BloodPressure": 70,
  "BMI": 25.5,
  "Age": 30
}
```

## 5. Contoh Response API

```json
{
  "prediction": 0,
  "result": "Low Diabetes Risk",
  "probability": 0.23,
  "risk_level": "Low"
}
```

## Catatan

Frontend tetap menggunakan 5 input sesuai file Dart awal. Backend tetap dilatih dengan 8 fitur dataset Pima. Tiga fitur yang tidak dikirim Flutter, yaitu `SkinThickness`, `Insulin`, dan `DiabetesPedigreeFunction`, akan dianggap kosong dan ditangani oleh `SimpleImputer` pada pipeline model.
