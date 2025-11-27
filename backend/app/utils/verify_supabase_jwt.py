# app/utils/verify_supabase_jwt.py
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt, JWTError
from app.config import settings
from typing import Dict

auth_scheme = HTTPBearer()

def decode_supabase_jwt(token: str) -> Dict:
    """
    Attempt to decode Supabase JWT. Supabase uses HS256 with the project's JWT secret.
    """
    try:
        # try with audience 'authenticated' first (common)
        payload = jwt.decode(token, settings.SUPABASE_JWT_SECRET, algorithms=["HS256"], options={"verify_aud": False})
        return payload
    except JWTError as e:
        raise

def get_token_payload(credentials: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    token = credentials.credentials
    try:
        payload = decode_supabase_jwt(token)
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    # payload should contain 'sub' - the user id
    if "sub" not in payload:
        raise HTTPException(status_code=401, detail="Token payload missing 'sub'")
    return payload
