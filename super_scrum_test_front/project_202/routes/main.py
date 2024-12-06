from fastapi import FastAPI, HTTPException, Depends, Form
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from . import models
from .db_config import get_db, Base, engine
from datetime import datetime, timedelta
import bcrypt
import jwt  # This is the more common import
from .models import User
from passlib.context import CryptContext
from dotenv import load_dotenv
import os
from sqlalchemy.exc import IntegrityError
from fastapi import Request
import json
from .routers import restaurants, users, auth, owners

# Get the absolute path of the directory containing your script
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
# Construct path to .env file
env_path = os.path.join(BASE_DIR, '.env')
load_dotenv(dotenv_path=env_path)

app = FastAPI()
origins = ["*"]  

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

models.Base.metadata.create_all(bind=engine)
app.include_router(restaurants.router)
app.include_router(users.router)
app.include_router(auth.router)
app.include_router(owners.router)

@app.get("/restaurants")
async def get_all_restaurants(db: Session = Depends(get_db)):
    try:
        restaurants = db.query(models.Restaurant).all()
        return {"restaurants": restaurants}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))