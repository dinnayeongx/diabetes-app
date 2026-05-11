#!/usr/bin/env bash
cd backend || exit 1
pip install -r requirements.txt
python train_model.py
uvicorn main:app --reload --host 0.0.0.0 --port 8000
