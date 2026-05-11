@echo off
cd backend
pip install -r requirements.txt
python train_model.py
uvicorn main:app --reload --host 0.0.0.0 --port 8000
pause
