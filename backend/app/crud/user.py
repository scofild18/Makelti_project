# app/crud/user.py
from sqlalchemy.orm import Session
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate
from typing import Optional
from uuid import UUID

def get_user(db: Session, user_id: UUID) -> Optional[User]:
    return db.query(User).filter(User.id == user_id).first()

def create_user(db: Session, user_in: UserCreate) -> User:
    user = User(
        id=user_in.id,
        email=user_in.email,
        full_name=user_in.full_name,
        phone=user_in.phone,
        user_type=user_in.user_type,
        profile_picture=user_in.profile_picture,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

def update_user(db: Session, user: User, data: UserUpdate) -> User:
    for field, value in data.dict(exclude_unset=True).items():
        setattr(user, field, value)
    db.add(user)
    db.commit()
    
    db.refresh(user)
    return user

def create_or_update_user(db: Session, user_in: UserCreate) -> User:
    existing = get_user(db, user_in.id)
    if existing:
        # update basic fields if provided
        update_data = {k: v for k, v in user_in.dict(exclude_unset=True).items() if k != "id"}
        for k, v in update_data.items():
            setattr(existing, k, v)
        db.add(existing)
        db.commit()
        db.refresh(existing)
        return existing
    return create_user(db, user_in)
