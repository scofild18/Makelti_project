from fastapi import FastAPI
from contextlib import asynccontextmanager
from app.config import settings
from app.api.v1 import auth, users
from app.api.v1 import cloudinary as cloudinary_router  # ✅ Add this
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
    # Shutdown logic
    print("Shutting down...")

app = FastAPI(title="Makelti", version="1.0.0", lifespan=lifespan)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["auth"])
app.include_router(users.router, prefix="/api/v1/users", tags=["users"])
app.include_router(cloudinary_router.router, prefix="/api/v1/cloudinary", tags=["cloudinary"])  # ✅ Add this

@app.get("/")
def root():
    return {"status": "ok", "project": "Maklti Backend"}