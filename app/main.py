from fastapi import FastAPI
from app.routers import items, users, health

app = FastAPI(
    title="ShopFast - Production-Ready E-commerce API",
    version="1.0.0",
    description="Built with FastAPI + EKS + Terraform + GitHub Actions OIDC"
)

app.include_router(health.router)
app.include_router(users.router, prefix="/api/v1/users", tags=["users"])
app.include_router(items.router, prefix="/api/v1/items", tags=["items"])

@app.get("/")
def root():
    return {"message": "ShopFast API is LIVE on AWS EKS! Built by coolhead "}
