from fastapi import FastAPI
from app.rag.api import router as rag_router
from app.rag.settings import settings
from app.rag.db import init_db

app = FastAPI(title="rag-demo", version="0.1.0")

@app.on_event("startup")
def _startup() -> None:
    init_db()

@app.get("/health")
def health() -> dict:
    return {"status": "ok", "mode": settings.mode}

app.include_router(rag_router)
