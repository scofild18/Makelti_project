# app/api/v1/cooks.py
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from uuid import UUID
from typing import List, Optional

from app.database import get_db
from app.utils.verify_supabase_jwt import get_token_payload
from app.crud import cook as crud_cook
from app.schemas.cook import (
    CookProfileCreate,
    CookProfileUpdate,
    CookProfileResponse,
    CookProfileWithDistance
)

router = APIRouter()


@router.get("/", response_model=List[CookProfileResponse])
def get_cook_profiles(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(100, ge=1, le=100, description="Maximum records to return"),
    city: Optional[str] = Query(None, description="Filter by city name"),
    is_active: Optional[str] = Query(None, description="Filter by status (active/inactive/suspended)"),
    db: Session = Depends(get_db),
    token_payload: dict = Depends(get_token_payload)
):
    """
    Retrieve all cook profiles with pagination and optional filters.
    
    - **skip**: Number of records to skip (for pagination)
    - **limit**: Maximum number of records to return (max 100)
    - **city**: Optional city filter (case-insensitive partial match)
    - **is_active**: Optional status filter
    """
    profiles = crud_cook.get_all_cook_profiles(
        db=db,
        skip=skip,
        limit=limit,
        city=city,
        is_active=is_active
    )
    return profiles


@router.get("/nearby", response_model=List[CookProfileWithDistance])
def get_nearby_cook_profiles(
    latitude: float = Query(..., ge=-90, le=90, description="Latitude coordinate"),
    longitude: float = Query(..., ge=-180, le=180, description="Longitude coordinate"),
    radius_km: float = Query(50.0, gt=0, le=200, description="Search radius in kilometers"),
    limit: int = Query(20, ge=1, le=50, description="Maximum results to return"),
    db: Session = Depends(get_db),
    token_payload: dict = Depends(get_token_payload)
):
    """
    Find nearby cook profiles based on geographic coordinates.
    
    Uses the Haversine formula to calculate distances and returns cooks
    within the specified radius, sorted by distance.
    
    - **latitude**: User's latitude
    - **longitude**: User's longitude
    - **radius_km**: Search radius (default 50km, max 200km)
    - **limit**: Maximum results (default 20, max 50)
    """
    results = crud_cook.get_nearby_cooks(
        db=db,
        latitude=latitude,
        longitude=longitude,
        radius_km=radius_km,
        limit=limit
    )
    
    # Convert to response model with distance
    response = []
    for profile, distance in results:
        profile_dict = CookProfileResponse.model_validate(profile).model_dump()
        profile_dict['distance_km'] = round(distance, 2)
        response.append(CookProfileWithDistance(**profile_dict))
    
    return response


@router.get("/{profile_id}", response_model=CookProfileResponse)
def get_cook_profile_by_id(
    profile_id: UUID,
    db: Session = Depends(get_db),
    token_payload: dict = Depends(get_token_payload)
):
    """
    Retrieve a specific cook profile by ID.
    
    - **profile_id**: UUID of the cook profile
    """
    profile = crud_cook.get_cook_profile(db, profile_id)
    if not profile:
        raise HTTPException(status_code=404, detail="Cook profile not found")
    
    return profile


@router.post("/", response_model=CookProfileResponse, status_code=201)
def create_cook_profile(
    profile_data: CookProfileCreate,
    db: Session = Depends(get_db),


    ##hadi dertelha comment for now 
    ##token_payload: dict = Depends(get_token_payload)
):
    """
    Create a new cook profile.
    
    Requirements:
    - User must exist and have user_type='cook'
    - User can only have one cook profile
    - Authenticated user must be creating their own profile
    """
    # Verify the authenticated user is creating their own profile

    #hadi aussi 
    # authenticated_user_id = token_payload["sub"]
    # if str(profile_data.user_id) != str(authenticated_user_id):
    #     raise HTTPException(
    #         status_code=403,
    #         detail="You can only create a cook profile for yourself"
    #     )
    
    try:
        profile = crud_cook.create_cook_profile(db, profile_data)
        return profile
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.put("/{profile_id}", response_model=CookProfileResponse)
def update_cook_profile(
    profile_id: UUID,
    update_data: CookProfileUpdate,
    db: Session = Depends(get_db),
    token_payload: dict = Depends(get_token_payload)
):
    """
    Update an existing cook profile.
    
    Only the profile owner can update their profile.
    
    - **profile_id**: UUID of the cook profile to update
    """
    # Get the profile
    profile = crud_cook.get_cook_profile(db, profile_id)
    if not profile:
        raise HTTPException(status_code=404, detail="Cook profile not found")
    
    # Verify ownership
    authenticated_user_id = token_payload["sub"]
    if str(profile.user_id) != str(authenticated_user_id):
        raise HTTPException(
            status_code=403,
            detail="You can only update your own cook profile"
        )
    
    # Update the profile
    updated_profile = crud_cook.update_cook_profile(db, profile, update_data)
    return updated_profile


@router.delete("/{profile_id}", status_code=204)
def delete_cook_profile(
    profile_id: UUID,
    db: Session = Depends(get_db),
    token_payload: dict = Depends(get_token_payload)
):
    """
    Delete a cook profile.
    
    Only the profile owner can delete their profile.
    
    - **profile_id**: UUID of the cook profile to delete
    """
    # Get the profile
    profile = crud_cook.get_cook_profile(db, profile_id)
    if not profile:
        raise HTTPException(status_code=404, detail="Cook profile not found")
    
    # Verify ownership
    authenticated_user_id = token_payload["sub"]
    if str(profile.user_id) != str(authenticated_user_id):
        raise HTTPException(
            status_code=403,
            detail="You can only delete your own cook profile"
        )
    
    # Delete the profile
    crud_cook.delete_cook_profile(db, profile)
    return None