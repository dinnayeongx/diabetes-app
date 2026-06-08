# Backend FastAPI - Diabetes Detection

## Isi Folder

```txt
backend/
├── main.py                     # API FastAPI
├── model.pkl                   # Model
├── requirements.txt            # Library Python
└── diabetes.csv                # Letakkan dataset di sini
```

## Library Backend

```txt
fastapi
uvicorn
pandas
numpy
scikit-learn
joblib
pydantic
```

## Cara Menjalankan

Masuk ke folder backend:

```bash
cd backend
```

Jalankan API:

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Buka dokumentasi API:

```txt
http://127.0.0.1:8000/docs
```

## Endpoint Prediction

```txt
POST /predict
```

Contoh body:

```json
{
  "Pregnancies": 2,
  "Glucose": 130,
  "BMI": 32,
  "Age": 38,
  "DiabetesPedigreeFunction": 0.87
}
```

Contoh response:

```json
{
  "prediction": 0,
  "result": "Low Diabetes Risk",
  "probability": 41.7,
  "risk_level": "Medium"
}
```
