from pydantic import BaseModel, EmailStr
from typing import Optional, List
from datetime import datetime

class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str
    role: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

class ClubCreate(BaseModel):
    name: str
    description: Optional[str] = None
    author_id: int
    form_link: Optional[str] = None

class ClubOut(ClubCreate):
    id: int
    created_at: datetime

    class Config:
        orm_mode = True

class EventCreate(BaseModel):
    name: str
    date: datetime
    description: Optional[str] = None
    club_id: int
    points: int = 0

class EventOut(EventCreate):
    id: int

    class Config:
        orm_mode = True

class MembershipCreate(BaseModel):
    user_id: int
    club_id: int
    status: str = "pending"

class MembershipOut(MembershipCreate):
    id: int

    class Config:
        orm_mode = True

class RegistrationCreate(BaseModel):
    user_id: int
    event_id: int
    status: str
    check_in: bool = False

class RegistrationOut(RegistrationCreate):
    id: int

    class Config:
        orm_mode = True

class ForgotPasswordRequest(BaseModel):
    email: EmailStr

class ResetPasswordRequest(BaseModel):
    email: EmailStr
    code: str
    new_password: str
