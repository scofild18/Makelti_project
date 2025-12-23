# app/crud/cook.py
from sqlalchemy.orm import Session
from sqlalchemy import func, text
from app.models.cook_profile import CookProfile
from app.models.user import User
from app.schemas.cook import CookProfileCreate, CookProfileUpdate
from typing import Optional, List
from uuid import UUID
import math


def get_cook_profile(db: Session, profile_id: UUID) -> Optional[CookProfile]:
    """Retrieve a single cook profile by ID"""
    return db.query(CookProfile).filter(CookProfile.id == profile_id).first()


def get_cook_profile_by_user_id(db: Session, user_id: UUID) -> Optional[CookProfile]:
    """Retrieve a cook profile by user ID"""
    return db.query(CookProfile).filter(CookProfile.user_id == user_id).first()


def get_all_cook_profiles(
    db: Session, 
    skip: int = 0, 
    limit: int = 100,
    city: Optional[str] = None,
    is_active: Optional[str] = None
) -> List[CookProfile]:
    """Retrieve all cook profiles with optional filtering"""
    query = db.query(CookProfile)
    
    if city:
        query = query.filter(CookProfile.city.ilike(f"%{city}%"))
    
    if is_active:
        query = query.filter(CookProfile.is_active == is_active)
    
    return query.offset(skip).limit(limit).all()


def create_cook_profile(db: Session, profile_data: CookProfileCreate) -> CookProfile:
    """Create a new cook profile"""
    # Verify user exists and is a cook
    user = db.query(User).filter(User.id == profile_data.user_id).first()
    if not user:
        raise ValueError("User not found")
    
    if user.user_type != "cook":
        raise ValueError("User must be a cook to create a cook profile")
    
    # Check if profile already exists
    existing = get_cook_profile_by_user_id(db, profile_data.user_id)
    if existing:
        raise ValueError("Cook profile already exists for this user")
    
    # Create new profile
    profile = CookProfile(
        user_id=profile_data.user_id,
        store_name=profile_data.store_name,
        bio=profile_data.bio,
        specialty=profile_data.specialty,
        city=profile_data.city,
        address=profile_data.address,
        latitude=profile_data.latitude,
        longitude=profile_data.longitude,
    )
    
    db.add(profile)
    db.commit()
    db.refresh(profile)
    return profile


def update_cook_profile(
    db: Session, 
    profile: CookProfile, 
    update_data: CookProfileUpdate
) -> CookProfile:
    """Update an existing cook profile"""
    for field, value in update_data.model_dump(exclude_unset=True).items():
        setattr(profile, field, value)
    
    db.add(profile)
    db.commit()
    db.refresh(profile)
    return profile


def delete_cook_profile(db: Session, profile: CookProfile) -> bool:
    """Delete a cook profile"""
    db.delete(profile)
    db.commit()
    return True


def get_nearby_cooks(
    db: Session,
    latitude: float,
    longitude: float,
    radius_km: float = 50.0,
    limit: int = 20
) -> List[tuple[CookProfile, float]]:
    """
    Find nearby cook profiles using the Haversine formula.
    Returns list of (CookProfile, distance_km) tuples.
    """
    # Haversine formula for distance calculation
    # Distance in km = 6371 * 2 * ASIN(SQRT(
    #   POWER(SIN((lat2 - lat1) * PI() / 180 / 2), 2) +
    #   COS(lat1 * PI() / 180) * COS(lat2 * PI() / 180) *
    #   POWER(SIN((lon2 - lon1) * PI() / 180 / 2), 2)
    # ))
    
    query = db.query(
        CookProfile,
        (
            6371 * 2 * func.asin(
                func.sqrt(
                    func.power(
                        func.sin((CookProfile.latitude - latitude) * func.pi() / 180 / 2), 
                        2
                    ) +
                    func.cos(latitude * func.pi() / 180) *
                    func.cos(CookProfile.latitude * func.pi() / 180) *
                    func.power(
                        func.sin((CookProfile.longitude - longitude) * func.pi() / 180 / 2),
                        2
                    )
                )
            )
        ).label('distance')
    ).filter(
        CookProfile.latitude.isnot(None),
        CookProfile.longitude.isnot(None),
        CookProfile.is_active == "active"
    )
    
    # Filter by radius
    results = query.all()
    filtered_results = [(profile, distance) for profile, distance in results if distance <= radius_km]
    
    # Sort by distance
    filtered_results.sort(key=lambda x: x[1])
    
    return filtered_results[:limit]


def update_cook_statistics(
    db: Session,
    cook_profile: CookProfile,
    new_order_total: Optional[float] = None,
    increment_orders: bool = False
) -> CookProfile:
    """
    Update cook statistics (for integration with order system).
    This is a helper function for when orders are processed.
    """
    if new_order_total is not None:
        cook_profile.total_sales += new_order_total
    
    if increment_orders:
        cook_profile.total_orders += 1
    
    db.add(cook_profile)
    db.commit()
    db.refresh(cook_profile)
    return cook_profile