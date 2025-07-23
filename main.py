# main.py
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello, CovHack!"}

@app.get("/health")
async def health_check():
    return {"status": "ok"}
