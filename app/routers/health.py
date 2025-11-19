# app/routers/health.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/healthz", tags=["health"])
def healthz():
    # keep this dirt-cheap: no DB/Redis calls
    return {"status": "ok"}

@router.get("/readyz", tags=["health"])
def readyz():
    # if you later want to check deps, do it here (but keep it fast)
    return {"status": "ready"}
