from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List

import database
import schemas
import crud

app = FastAPI(title="Hands-On 6: Modular FastAPI")

# Note: In Hands-On 7, Alembic handles table creation. 
# If you aren't using Alembic yet for this step, you can create tables on startup:
# @app.on_event("startup")
# async def startup():
#     async with database.engine.begin() as conn:
#         await conn.run_sync(database.Base.metadata.create_all)

@app.get("/")
async def root():
    return {"message": "Welcome to the Hands-On 6 API!"}

# ==========================================
# Update these routes to match your crud.py functions!
# ==========================================

@app.post("/items/", response_model=schemas.Item)
async def create_item(item: schemas.ItemCreate, db: AsyncSession = Depends(database.get_db)):
    """Create a new item in the database."""
    return await crud.create_item(db=db, item=item)

@app.get("/items/{item_id}", response_model=schemas.Item)
async def read_item(item_id: int, db: AsyncSession = Depends(database.get_db)):
    """Fetch an item by its ID."""
    db_item = await crud.get_item(db=db, item_id=item_id)
    if db_item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return db_item

@app.get("/items/", response_model=List[schemas.Item])
async def read_items(skip: int = 0, limit: int = 10, db: AsyncSession = Depends(database.get_db)):
    """Fetch a list of items."""
    return await crud.get_items(db=db, skip=skip, limit=limit)