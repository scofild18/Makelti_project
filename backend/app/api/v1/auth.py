# app/api/v1/auth.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.utils.verify_supabase_jwt import get_token_payload
from app.database import get_db
from app.crud import user as crud_user
from app.schemas.user import UserCreate, UserResponse

router = APIRouter()

@router.get("/me", response_model=dict)
def get_current_user(token_payload: dict = Depends(get_token_payload)):
    """
    Returns the JWT payload — including sub (user id) and claims.
    Useful for debugging and client to verify current session.
    """
    # You can customize which claims to return
    return token_payload

@router.post("/sync", response_model=UserResponse)
def sync_user_profile(data: UserCreate, db: Session = Depends(get_db), token_payload: dict = Depends(get_token_payload)):
    """
    Synchronize an extended profile in our local DB.
    The client should call this after registering/logging in with Supabase.
    - data.id must equal token_payload['sub'] to be allowed.
    """
    sub = token_payload["sub"]
    if str(data.id) != str(sub):
        # the JWT subject must match the id supplied
        from fastapi import HTTPException
        raise HTTPException(status_code=403, detail="ID mismatch with token")
    user = crud_user.create_or_update_user(db, data)
    return user
