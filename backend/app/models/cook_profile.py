# app/models/cook_profile.py
from sqlalchemy import Column, String, DateTime, Text, Float, ForeignKey, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from app.database import Base


class CookProfile(Base):
    __tablename__ = "cook_profiles"
    
    id = Column(UUID(as_uuid=True), primary_key=True, server_default=func.gen_random_uuid())
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    
    # Store information
    store_name = Column(String(255), nullable=False)
    bio = Column(Text, nullable=True)
    specialty = Column(String(255), nullable=True)  # e.g., "Italian Cuisine", "Desserts"
    
    # Location data
    city = Column(String(100), nullable=True)
    address = Column(Text, nullable=True)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    
    # Statistics (can be computed or cached)
    total_sales = Column(Float, default=0.0, nullable=False)
    total_orders = Column(Float, default=0, nullable=False)
    average_rating = Column(Float, default=0.0, nullable=False)
    
    # Status
    is_active = Column(String(50), default="active", nullable=False)  # active, inactive, suspended
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)
    
    # Relationships
    user = relationship("User", backref="cook_profile", uselist=False)