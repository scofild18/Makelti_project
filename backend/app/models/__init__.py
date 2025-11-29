# app/models/__init__.py
from app.database import Base
from app.models import user  # so importing this module registers model classes with Base
