# app/db.py
import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from .models import Base

engine = create_engine(os.environ["DATABASE_URL"], pool_pre_ping=True)
SessionLocal = sessionmaker(bind=engine, expire_on_commit=False)

class DB:
    def __enter__(self): 
        self.s = SessionLocal(); return self.s
    def __exit__(self, *a):
        self.s.close()
db = DB()
