# app/api/v1/users.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from uuid import UUID
from app.database import get_db
from app.utils.verify_supabase_jwt import get_token_payload
from app.crud import user as crud_user
from app.schemas.user import UserResponse, UserUpdate

router = APIRouter()

@router.get("/{user_id}", response_model=UserResponse)
def get_user(user_id: UUID, db: Session = Depends(get_db), token_payload: dict = Depends(get_token_payload)):
    sub = token_payload["sub"]
    if str(sub) != str(user_id):
        raise HTTPException(status_code=403, detail="Forbidden")
    user = crud_user.get_user(db, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.put("/{user_id}", response_model=UserResponse)
def update_user(user_id: UUID, data: UserUpdate, db: Session = Depends(get_db), token_payload: dict = Depends(get_token_payload)):
    sub = token_payload["sub"]
    if str(sub) != str(user_id):
        raise HTTPException(status_code=403, detail="Forbidden")
    user = crud_user.get_user(db, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    updated = crud_user.update_user(db, user, data)
    return updated
