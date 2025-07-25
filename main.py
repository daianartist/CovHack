# main.py
from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from models import User, Base, Club, Event, Membership, Registration
from schemas import UserCreate, UserLogin, Token, ClubCreate, ClubOut, EventCreate, EventOut, MembershipCreate, MembershipOut, RegistrationCreate, RegistrationOut
from auth_utils import hash_password, verify_password
from jwt_utils import create_access_token
from database import get_db  # You need a get_db dependency for SQLAlchemy session
from auth import get_current_user

app = FastAPI()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

# Email request models
class EmailConfig(BaseModel):
    email: str
    password: str
    smtp_server: str
    smtp_port: int

class Participant(BaseModel):
    name: str
    email: str
    verification_code: str

class EmailRequest(BaseModel):
    config: EmailConfig
    participants: List[Participant]
    event_name: str = "CovHack"
    base_url: str = "https://certificateverifier.vercel.app/verify?code="

@app.post("/register", response_model=Token)
def register(user: UserCreate, db: Session = Depends(get_db)):
    # Check if user exists
    if db.query(User).filter(User.email == user.email).first():
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_pw = hash_password(user.password)
    db_user = User(name=user.name, email=user.email, password=hashed_pw, role=user.role)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    access_token = create_access_token(data={"sub": db_user.email})
    return {"access_token": access_token, "token_type": "bearer"}

@app.post("/login", response_model=Token)
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    user = db.query(User).filter(User.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    access_token = create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer"}

@app.get("/me", response_model=UserOut)
def read_users_me(current_user: User = Depends(get_current_user)):
    return {
        "id": current_user.id,
        "name": current_user.name,
        "email": current_user.email,
        "role": current_user.role
    }
