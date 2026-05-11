# Backend FastAPI - Diabetes Detection

## Isi Folder

```txt
backend/
├── main.py              # API FastAPI
├── train_model.py       # Training model diabetes
├── requirements.txt     # Library Python
├── sample_request.json  # Contoh request JSON
└── diabetes.csv         # Letakkan dataset di sini
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

Install library:

```bash
pip install -r requirements.txt
```

Letakkan dataset dengan nama:

```txt
diabetes.csv
```

Dataset minimal harus punya kolom:

```txt
Pregnancies, Glucose, BloodPressure, SkinThickness, Insulin, BMI, DiabetesPedigreeFunction, Age, Outcome
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
  "Glucose": 120,
  "BloodPressure": 70,
  "BMI": 25.5,
  "Age": 30
}
```

Contoh response:

```json
{
  "prediction": 0,
  "result": "Low Diabetes Risk",
  "probability": 0.23,
  "risk_level": "Low"
}
```
