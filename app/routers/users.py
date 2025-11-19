from fastapi import APIRouter

router = APIRouter()

@router.get("/me")
async def read_current_user():
    return {"username": "coolhead", "role": "admin"}
