from fastapi import FastAPI
from app.routers import health

app = FastAPI()

app.include_router(health.router)

@app.get("/")
async def root():
    return {"message": "FastAPI is running with uv"}