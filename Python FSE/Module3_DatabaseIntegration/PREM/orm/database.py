from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, declarative_base

# Replace with your actual database URL (e.g., PostgreSQL or async SQLite)
# Example for Async SQLite: "sqlite+aiosqlite:///./handson6.db"
# Example for Async PostgreSQL: "postgresql+asyncpg://user:password@localhost/dbname"
SQLALCHEMY_DATABASE_URL = "sqlite+aiosqlite:///./handson6.db"

# Create the async engine
engine = create_async_engine(
    SQLALCHEMY_DATABASE_URL, 
    echo=True, # Set to False in production
    # connect_args={"check_same_thread": False} # Uncomment if using SQLite
)

# Create a configured "SessionLocal" class
SessionLocal = sessionmaker(
    bind=engine, 
    class_=AsyncSession, 
    expire_on_commit=False,
    autocommit=False,
    autoflush=False
)

# Create a Base class for your models to inherit from
Base = declarative_base()

# Dependency to get the async database session
async def get_db():
    async with SessionLocal() as session:
        try:
            yield session
        finally:
            await session.close()