# app/schemas/cook.py
from pydantic import BaseModel, ConfigDict, Field
from typing import Optional
from datetime import datetime
from uuid import UUID


class CookProfileBase(BaseModel):
    store_name: str = Field(..., min_length=1, max_length=255, description="Name of the cook's store")
    bio: Optional[str] = Field(None, description="Biography or description of the cook")
    specialty: Optional[str] = Field(None, max_length=255, description="Cooking specialty")
    city: Optional[str] = Field(None, max_length=100, description="City location")
    address: Optional[str] = Field(None, description="Full address")
    latitude: Optional[float] = Field(None, ge=-90, le=90, description="Latitude coordinate")
    longitude: Optional[float] = Field(None, ge=-180, le=180, description="Longitude coordinate")


class CookProfileCreate(CookProfileBase):
    """Schema for creating a new cook profile"""
    user_id: UUID = Field(..., description="Associated user ID (must be a cook)")


class CookProfileUpdate(BaseModel):
    """Schema for updating cook profile - all fields optional"""
    store_name: Optional[str] = Field(None, min_length=1, max_length=255)
    bio: Optional[str] = None
    specialty: Optional[str] = Field(None, max_length=255)
    city: Optional[str] = Field(None, max_length=100)
    address: Optional[str] = None
    latitude: Optional[float] = Field(None, ge=-90, le=90)
    longitude: Optional[float] = Field(None, ge=-180, le=180)
    is_active: Optional[str] = Field(None, pattern="^(active|inactive|suspended)$")


class CookProfileResponse(CookProfileBase):
    """Schema for cook profile responses"""
    model_config = ConfigDict(from_attributes=True)
    
    id: UUID
    user_id: UUID
    total_sales: float
    total_orders: float
    average_rating: float
    is_active: str
    created_at: datetime
    updated_at: datetime


class CookProfileWithDistance(CookProfileResponse):
    """Schema for cook profile with distance calculation"""
    distance_km: Optional[float] = Field(None, description="Distance in kilometers from search point")