# app/config.py
from pydantic_settings import BaseSettings  
from functools import lru_cache


class Settings(BaseSettings):
    # Database
    DATABASE_URL: str
    
    # Supabase
    SUPABASE_URL: str
    SUPABASE_KEY: str
    SUPABASE_JWT_SECRET: str
    
    # JWT
    SECRET_KEY: str = "change-me-in-production"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60
    
    # Project
    PROJECT_NAME: str = "Maklti"
    VERSION: str = "1.0.0"
    
    class Config:
        env_file = ".env"
        case_sensitive = True


@lru_cache()
def get_settings() -> Settings:
    return Settings()


settings = get_settings()