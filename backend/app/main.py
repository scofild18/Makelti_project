# app/main.py
from fastapi import FastAPI
from contextlib import asynccontextmanager
from app.config import settings
from app.api.v1 import auth, users, cooks
from app.database import engine
from app import models
from sqlalchemy import text


# WARNING: On production manage migrations outside of this script.
models.Base.metadata.create_all(bind=engine)


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup logic
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        print("✅ Database connected successfully!")
    except Exception as e:
        print(f"❌ Database connection failed: {e}")
    yield
    # Shutdown logic (if any) can go here
    print("Shutting down...")


app = FastAPI(
    title="Makelti",
    version="1.0.0",
    lifespan=lifespan,
    description="Makelti API - Homemade meals marketplace platform"
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["auth"])
app.include_router(users.router, prefix="/api/users", tags=["users"])
app.include_router(cooks.router, prefix="/api/cooks", tags=["cooks"])


@app.get("/")
def root():
    return {
        "status": "ok",
        "project": "Makelti Backend",
        "version": "1.0.0"
    }