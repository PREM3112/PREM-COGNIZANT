from pydantic import BaseModel, ConfigDict
from typing import Optional

# ==========================================
# IMPORTANT: Rename 'Item' to match the entity 
# you defined in your models.py (e.g., Student, Course)
# ==========================================

# Base schema with shared properties
class ItemBase(BaseModel):
    name: str
    description: Optional[str] = None
    # Add other common fields here

# Schema for creating a new record (inherits Base)
class ItemCreate(ItemBase):
    pass
    # Add any fields required specifically for creation (e.g., passwords)

# Schema for reading a record (includes the database ID)
class Item(ItemBase):
    id: int

    # This tells Pydantic to read data even if it's an ORM model, not a dict
    model_config = ConfigDict(from_attributes=True)