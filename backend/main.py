from pathlib import Path
from typing import Optional

import joblib
import numpy as np
import pandas as pd
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

BASE_DIR = Path(__file__).resolve().parent
MODEL_PATH = BASE_DIR / "model.pkl"

FEATURES = [
    'Glucose', 'BMI', 'Age', 'Pregnancies', 'DiabetesPedigreeFunction'
]

app = FastAPI(
    title="Diabetes Risk Detection API",
    description="API prediksi risiko diabetes untuk frontend Flutter.",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

bundle = joblib.load(MODEL_PATH)

model = bundle["model"]
FEATURES = bundle["fitur"]

print("Fitur model:", FEATURES)

class DiabetesInput(BaseModel):
    Pregnancies: float = Field(..., ge=0)
    Glucose: float = Field(..., ge=0)
    # BloodPressure: float = Field(..., ge=0)
    BMI: float = Field(..., ge=0)
    Age: float = Field(..., ge=0)
    # SkinThickness: float = Field(..., ge=0)
    # Insulin: float = Field(..., ge=0)
    DiabetesPedigreeFunction: float = Field(..., ge=0)

class PredictionResponse(BaseModel):
    prediction: int
    result: str
    probability: float
    risk_level: str


@app.get("/")
def root():
    return {"message": "API running"}


@app.get("/health")
def health():
    return {"model_loaded": True}


@app.post("/predict", response_model=PredictionResponse)
def predict(data: DiabetesInput):

    try:
        input_dict = data.model_dump()

        row = {feature: input_dict.get(feature) for feature in FEATURES}

        df = pd.DataFrame([row], columns=FEATURES)

        prediction = int(model.predict(df)[0])

        probability = float(
            model.predict_proba(df)[0][1]
        )

        if probability >= 0.70:
            risk_level = "High"
        elif probability >= 0.40:
            risk_level = "Medium"
        else:
            risk_level = "Low"

        result = (
            "High Diabetes Risk"
            if prediction == 1
            else "Low Diabetes Risk"
        )

        return PredictionResponse(
            prediction=prediction,
            result=result,
            probability=probability,
            risk_level=risk_level,
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))