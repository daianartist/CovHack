# main.py
from fastapi import FastAPI, Depends, HTTPException, Path, UploadFile, File
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session
from models import User, Base, Club, Event, Membership, Registration
from schemas import (
    PostCreate, PostOut, UserCreate, UserLogin, Token, ClubCreate, ClubOut, ClubUpdate, ClubWithMembers,
    EventCreate, EventOut, MembershipCreate, MembershipOut, RegistrationCreate, 
    RegistrationOut, UserOut, ForgotPasswordRequest, ResetPasswordRequest, 
    PollCreate, PollOut, PollVote, PollResults, AssignModeratorRequest
)
from auth_utils import hash_password, verify_password
from jwt_utils import create_access_token
from database import get_db  # You need a get_db dependency for SQLAlchemy session
from auth import get_current_user
from typing import List, Optional
from datetime import datetime
from sheets_utils import get_sheet_responses
from googleapiclient.errors import HttpError
import csv
from fastapi.responses import StreamingResponse
from io import StringIO
import time
from models import UserRole
from fastapi.middleware.cors import CORSMiddleware
import random
import string
import os
from sqlalchemy.orm import joinedload
from models import Post, Poll
import shutil

reset_codes = {}
_cache = {}
_cache_expiry = {}

def get_sheet_responses_cached(sheet_id, range_name):
    key = (sheet_id, range_name)
    now = time.time()
    if key in _cache and now < _cache_expiry[key]:
        return _cache[key]
    data = get_sheet_responses(sheet_id, range_name)
    _cache[key] = data
    _cache_expiry[key] = now + 600  # Cache for 10 minutes
    return data

def is_club_moderator(db, user_id, club_id):
    from models import MembershipRole, Membership
    membership = db.query(Membership).filter_by(user_id=user_id, club_id=club_id, role=MembershipRole.moderator).first()
    return membership is not None

app = FastAPI()

# Mount static files
app.mount("/static", StaticFiles(directory="static"), name="static")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Для разработки можно оставить *, для продакшена укажите конкретные адреса
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

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

### **Clubs**

@app.post("/clubs/", response_model=ClubOut)
def create_club(
    club: ClubCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    print("Current user role:", current_user.role, type(current_user.role))
    if current_user.role != UserRole.admin:
        raise HTTPException(status_code=403, detail="Only admins can create clubs")
    db_club = Club(
        name=club.name,
        description=club.description,
        author_id=current_user.id,
        form_link=club.form_link,
        sheet_id=club.sheet_id,
        range_name=club.range_name,
        image_url=club.image_url
    )
    db.add(db_club)
    db.commit()
    db.refresh(db_club)
    # Assign moderator if provided
    if club.moderator_id:
        from models import MembershipRole
        db_moderator = db.query(User).filter(User.id == club.moderator_id).first()
        if not db_moderator:
            raise HTTPException(status_code=404, detail="Moderator user not found")
        db_membership = Membership(
            user_id=club.moderator_id,
            club_id=db_club.id,
            status="approved",
            role=MembershipRole.moderator
        )
        db.add(db_membership)
        db.commit()
    return db_club

@app.get("/clubs/", response_model=List[ClubOut])
def get_clubs(db: Session = Depends(get_db)):
    return db.query(Club).all()

@app.get("/user/clubs/", response_model=List[ClubWithMembers])
def get_user_clubs(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    from models import MembershipRole
    # Получаем клубы, где пользователь является модератором
    memberships = db.query(Membership).filter(
        Membership.user_id == current_user.id,
        Membership.role == MembershipRole.moderator,
        Membership.status == "approved"
    ).all()
    
    # Получаем информацию о клубах с количеством участников
    clubs = []
    for membership in memberships:
        club = db.query(Club).filter(Club.id == membership.club_id).first()
        if club:
            # Подсчитываем количество участников
            member_count = db.query(Membership).filter(
                Membership.club_id == club.id,
                Membership.status == "approved"
            ).count()
            
            # Создаем объект с количеством участников
            club_with_members = {
                "id": club.id,
                "name": club.name,
                "description": club.description,
                "created_at": club.created_at,
                "members": member_count,
                "category": "Club"  # Пока используем статичное значение, можно добавить поле в модель
            }
            clubs.append(club_with_members)
    
    return clubs

@app.get("/clubs/{club_id}", response_model=ClubOut)
def get_club(club_id: int = Path(...), db: Session = Depends(get_db)):
    club = db.query(Club).filter(Club.id == club_id).first()
    if not club:
        raise HTTPException(status_code=404, detail="Club not found")
    return club

@app.put("/clubs/{club_id}", response_model=ClubOut)
def update_club(club_id: int, club: ClubUpdate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_club = db.query(Club).filter(Club.id == club_id).first()
    if not db_club:
        raise HTTPException(status_code=404, detail="Club not found")
    # Allow club author, admins, or club moderators to update
    if not (db_club.author_id == current_user.id or 
            current_user.role == UserRole.admin or 
            is_club_moderator(db, current_user.id, club_id)):
        raise HTTPException(status_code=403, detail="Not authorized to update this club")
    club_data = club.dict(exclude_unset=True)
    for key, value in club_data.items():
        if value is not None:
            setattr(db_club, key, value)
    db.commit()
    db.refresh(db_club)
    return db_club

@app.delete("/clubs/{club_id}")
def delete_club(club_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    if current_user.role != UserRole.admin:
        raise HTTPException(status_code=403, detail="Only admins can delete clubs")
    club = db.query(Club).filter(Club.id == club_id).first()
    if not club:
        raise HTTPException(status_code=404, detail="Club not found")
    db.delete(club)
    db.commit()
    return {"detail": "Club deleted"}

@app.put("/clubs/{club_id}/moderator")
def assign_club_moderator(
    club_id: int, 
    request: AssignModeratorRequest, 
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_user)
):
    # Only admins can assign moderators
    if current_user.role != UserRole.admin:
        raise HTTPException(status_code=403, detail="Only admins can assign moderators")
    
    # Check if club exists
    club = db.query(Club).filter(Club.id == club_id).first()
    if not club:
        raise HTTPException(status_code=404, detail="Club not found")
    
    # Check if moderator user exists
    moderator_user = db.query(User).filter(User.id == request.moderator_id).first()
    if not moderator_user:
        raise HTTPException(status_code=404, detail="Moderator user not found")
    
    # Check if membership already exists
    from models import MembershipRole
    existing_membership = db.query(Membership).filter(
        Membership.user_id == request.moderator_id,
        Membership.club_id == club_id
    ).first()
    
    if existing_membership:
        # Update existing membership to moderator role
        existing_membership.role = MembershipRole.moderator
        existing_membership.status = "approved"
        db.commit()
        return {"detail": f"User {moderator_user.name} promoted to moderator for club {club.name}"}
    else:
        # Create new membership with moderator role
        new_membership = Membership(
            user_id=request.moderator_id,
            club_id=club_id,
            status="approved",
            role=MembershipRole.moderator
        )
        db.add(new_membership)
        db.commit()
        return {"detail": f"User {moderator_user.name} assigned as moderator for club {club.name}"}

### **Events**

@app.post("/events/", response_model=EventOut)
def create_event(event: EventCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_club = db.query(Club).filter(Club.id == event.club_id).first()
    if not db_club:
        raise HTTPException(status_code=404, detail="Club not found")
    # Only admins or moderators of this club can create events
    if not (current_user.role == UserRole.admin or is_club_moderator(db, current_user.id, event.club_id)):
        raise HTTPException(status_code=403, detail="Not authorized to create event for this club")
    db_event = Event(
        name=event.name,
        date=event.date,
        description=event.description,
        club_id=event.club_id,
        points=event.points,
        image_url=event.image_url
    )
    db.add(db_event)
    db.commit()
    db.refresh(db_event)
    return db_event

@app.get("/events/", response_model=List[EventOut])
def get_events(db: Session = Depends(get_db)):
    return db.query(Event).all()

@app.get("/events/{event_id}", response_model=EventOut)
def get_event(event_id: int = Path(...), db: Session = Depends(get_db)):
    event = db.query(Event).filter(Event.id == event_id).first()
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    return event

### **Memberships**

@app.post("/memberships/", response_model=MembershipOut)
def create_membership(membership: MembershipCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    # Only allow users to request membership for themselves
    if membership.user_id != current_user.id and current_user.role != UserRole.admin:
        raise HTTPException(status_code=403, detail="Not authorized to create membership for another user")
    db_membership = Membership(**membership.dict())
    db.add(db_membership)
    db.commit()
    db.refresh(db_membership)
    return db_membership

@app.get("/memberships/", response_model=List[MembershipOut])
def get_memberships(db: Session = Depends(get_db)):
    return db.query(Membership).all()

@app.get("/memberships/{membership_id}", response_model=MembershipOut)
def get_membership(membership_id: int = Path(...), db: Session = Depends(get_db)):
    membership = db.query(Membership).filter(Membership.id == membership_id).first()
    if not membership:
        raise HTTPException(status_code=404, detail="Membership not found")
    return membership

@app.put("/memberships/{membership_id}/status", response_model=MembershipOut)
def update_membership_status(membership_id: int, status: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_membership = db.query(Membership).filter(Membership.id == membership_id).first()
    if not db_membership:
        raise HTTPException(status_code=404, detail="Membership not found")
    db_club = db.query(Club).filter(Club.id == db_membership.club_id).first()
    # Allow club author, admins, or club moderators to update membership status
    if not (db_club.author_id == current_user.id or 
            current_user.role == UserRole.admin or 
            is_club_moderator(db, current_user.id, db_membership.club_id)):
        raise HTTPException(status_code=403, detail="Not authorized to update membership for this club")
    db_membership.status = status
    db.commit()
    db.refresh(db_membership)
    return db_membership

### **Registrations**

@app.post("/registrations/", response_model=RegistrationOut)
def create_registration(registration: RegistrationCreate, db: Session = Depends(get_db)):
    db_registration = Registration(**registration.dict())
    db.add(db_registration)
    db.commit()
    db.refresh(db_registration)
    return db_registration

@app.get("/registrations/", response_model=List[RegistrationOut])
def get_registrations(db: Session = Depends(get_db)):
    return db.query(Registration).all()

@app.get("/registrations/{registration_id}", response_model=RegistrationOut)
def get_registration(registration_id: int = Path(...), db: Session = Depends(get_db)):
    registration = db.query(Registration).filter(Registration.id == registration_id).first()
    if not registration:
        raise HTTPException(status_code=404, detail="Registration not found")
    return registration

### **D. Filtering Example (Events by Club)**

@app.get("/clubs/{club_id}/events", response_model=List[EventOut])
def get_events_by_club(club_id: int, db: Session = Depends(get_db)):
    return db.query(Event).filter(Event.club_id == club_id).all()

@app.get("/clubs/{club_id}/memberships/pending", response_model=List[MembershipOut])
def get_pending_memberships(club_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_club = db.query(Club).filter(Club.id == club_id).first()
    if not db_club:
        raise HTTPException(status_code=404, detail="Club not found")
    # Allow club author, admins, or club moderators to view pending memberships
    if not (db_club.author_id == current_user.id or 
            current_user.role == UserRole.admin or 
            is_club_moderator(db, current_user.id, club_id)):
        raise HTTPException(status_code=403, detail="Not authorized to view pending memberships for this club")
    return db.query(Membership).filter(Membership.club_id == club_id, Membership.status == "pending").all()

@app.get("/clubs/{club_id}/applications")
def get_club_applications(
    club_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    club = db.query(Club).filter(Club.id == club_id).first()
    if not club:
        raise HTTPException(status_code=404, detail="Club not found")
    # Allow club author, admins, or club moderators to view applications
    if not (club.author_id == current_user.id or 
            current_user.role == UserRole.admin or 
            is_club_moderator(db, current_user.id, club_id)):
        raise HTTPException(status_code=403, detail="Not authorized")
    if not club.sheet_id or not club.range_name:
        raise HTTPException(status_code=400, detail="Sheet info not set for this club")
    try:
        responses = get_sheet_responses_cached(club.sheet_id, club.range_name)
    except HttpError as e:
        raise HTTPException(status_code=502, detail=f"Google Sheets error: {e}")
    return {"responses": responses}

@app.get("/clubs/{club_id}/applications/csv")
def get_club_applications_csv(
    club_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    club = db.query(Club).filter(Club.id == club_id).first()
    if not club:
        raise HTTPException(status_code=404, detail="Club not found")
    # Allow club author, admins, or club moderators to export applications
    if not (club.author_id == current_user.id or 
            current_user.role == UserRole.admin or 
            is_club_moderator(db, current_user.id, club_id)):
        raise HTTPException(status_code=403, detail="Not authorized")
    if not club.sheet_id or not club.range_name:
        raise HTTPException(status_code=400, detail="Sheet info not set for this club")
    try:
        responses = get_sheet_responses_cached(club.sheet_id, club.range_name)
    except HttpError as e:
        raise HTTPException(status_code=502, detail=f"Google Sheets error: {e}")
    si = StringIO()
    writer = csv.writer(si)
    for row in responses:
        writer.writerow(row)
    si.seek(0)
    return StreamingResponse(si, media_type="text/csv", headers={"Content-Disposition": "attachment; filename=applications.csv"})

@app.get("/clubs/{club_id}/questionnaire/url")
def get_club_questionnaire_url(club_id: int, db: Session = Depends(get_db)):
    club = db.query(Club).filter(Club.id == club_id).first()
    if not club:
        raise HTTPException(status_code=404, detail="Club not found")
    return {"questionnaire_url": club.questionnaire_url}
@app.post("/forgot-password")
def forgot_password(request: ForgotPasswordRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == request.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    code = ''.join(random.choices(string.digits, k=6))
    reset_codes[request.email] = code

    # Логируем код в файл
    log_path = os.path.join(os.getcwd(), "reset_codes_log.txt")
    with open(log_path, "a") as f:
        f.write(f"{request.email}: {code}\n")

    return {"detail": "Reset code sent", "code": code}

@app.post("/reset-password")
def reset_password(request: ResetPasswordRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == request.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    if request.email not in reset_codes or reset_codes[request.email] != request.code:
        raise HTTPException(status_code=400, detail="Invalid reset code")
    
    user.password = hash_password(request.new_password)
    db.commit()
    
    # Remove the used reset code
    del reset_codes[request.email]
    
    return {"detail": "Password reset successfully"}

### **Image Upload Endpoints**

ALLOWED_IMAGE_TYPES = ["image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"]
MAX_FILE_SIZE = 5 * 1024 * 1024  # 5MB

def save_uploaded_file(upload_file: UploadFile, folder: str, filename: str) -> str:
    """Save uploaded file and return the file path"""
    file_path = f"static/images/{folder}/{filename}"
    
    # Ensure directory exists
    os.makedirs(f"static/images/{folder}", exist_ok=True)
    
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(upload_file.file, buffer)
    
    return f"/static/images/{folder}/{filename}"

@app.post("/upload/club-image")
async def upload_club_image(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user)
):
    """Upload image for a club"""
    # Allow admins or moderators to upload club images
    if current_user.role not in [UserRole.admin, UserRole.moderator]:
        raise HTTPException(status_code=403, detail="Only admins and moderators can upload club images")
    
    if file.content_type not in ALLOWED_IMAGE_TYPES:
        raise HTTPException(status_code=400, detail="Invalid file type. Only JPEG, PNG, GIF, and WebP are allowed")
    
    if file.size and file.size > MAX_FILE_SIZE:
        raise HTTPException(status_code=400, detail="File too large. Maximum size is 5MB")
    
    # Generate unique filename
    file_extension = file.filename.split(".")[-1]
    filename = f"club_{int(time.time())}_{random.randint(1000, 9999)}.{file_extension}"
    
    file_path = save_uploaded_file(file, "clubs", filename)
    
    return {"image_url": file_path, "filename": filename}

@app.post("/upload/event-image")
async def upload_event_image(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user)
):
    """Upload image for an event"""
    # Allow admins or moderators to upload event images
    if current_user.role not in [UserRole.admin, UserRole.moderator]:
        raise HTTPException(status_code=403, detail="Only admins and moderators can upload event images")
    
    if file.content_type not in ALLOWED_IMAGE_TYPES:
        raise HTTPException(status_code=400, detail="Invalid file type. Only JPEG, PNG, GIF, and WebP are allowed")
    
    if file.size and file.size > MAX_FILE_SIZE:
        raise HTTPException(status_code=400, detail="File too large. Maximum size is 5MB")
    
    # Generate unique filename
    file_extension = file.filename.split(".")[-1]
    filename = f"event_{int(time.time())}_{random.randint(1000, 9999)}.{file_extension}"
    
    file_path = save_uploaded_file(file, "events", filename)
    
    return {"image_url": file_path, "filename": filename}

@app.post("/clubs/{club_id}/posts/", response_model=PostOut)
def create_post(club_id: int, post: PostCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    club = db.query(Club).filter(Club.id == club_id).first()
    if not club:
        raise HTTPException(status_code=404, detail="Club not found")
    # Only moderators of this club or admins can create
    if not (current_user.role == UserRole.admin or is_club_moderator(db, current_user.id, club_id)):
        raise HTTPException(status_code=403, detail="Not authorized to create post for this club")
    db_post = Post(
        club_id=club_id,
        author_id=current_user.id,
        description=post.description,
        image_url=post.image_url,
        event_id=post.event_id
    )
    db.add(db_post)
    db.commit()
    db.refresh(db_post)
    return db_post

@app.get("/clubs/{club_id}/posts/", response_model=List[PostOut])
def list_posts(club_id: int, db: Session = Depends(get_db)):
    posts = db.query(Post).filter(Post.club_id == club_id).order_by(Post.created_at.desc()).all()
    return posts

@app.get("/posts/{post_id}", response_model=PostOut)
def get_post(post_id: int, db: Session = Depends(get_db)):
    post = db.query(Post).options(joinedload(Post.event)).filter(Post.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")
    return post

@app.put("/posts/{post_id}", response_model=PostOut)
def update_post(post_id: int, post: PostCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_post = db.query(Post).filter(Post.id == post_id).first()
    if not db_post:
        raise HTTPException(status_code=404, detail="Post not found")
    club = db.query(Club).filter(Club.id == db_post.club_id).first()
    if not (current_user.role == UserRole.admin or is_club_moderator(db, current_user.id, club.id)):
        raise HTTPException(status_code=403, detail="Not authorized to update this post")
    db_post.description = post.description
    db_post.image_url = post.image_url
    db_post.event_id = post.event_id
    db.commit()
    db.refresh(db_post)
    return db_post

@app.delete("/posts/{post_id}")
def delete_post(post_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_post = db.query(Post).filter(Post.id == post_id).first()
    if not db_post:
        raise HTTPException(status_code=404, detail="Post not found")
    club = db.query(Club).filter(Club.id == db_post.club_id).first()
    if not (current_user.role == UserRole.admin or is_club_moderator(db, current_user.id, club.id)):
        raise HTTPException(status_code=403, detail="Not authorized to delete this post")
    db.delete(db_post)
    db.commit()
    return {"detail": "Post deleted"}

@app.post("/clubs/{club_id}/polls/", response_model=PollOut)
def create_poll(club_id: int, poll: PollCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    club = db.query(Club).filter(Club.id == club_id).first()
    if not club:
        raise HTTPException(status_code=404, detail="Club not found")
    # Only moderators of this club or admins can create polls
    if not (current_user.role == UserRole.admin or is_club_moderator(db, current_user.id, club_id)):
        raise HTTPException(status_code=403, detail="Not authorized to create poll for this club")
    if len(poll.options) < 2:
        raise HTTPException(status_code=400, detail="Poll must have at least 2 options")
    db_poll = Poll(
        club_id=club_id,
        author_id=current_user.id,
        question=poll.question,
        options=poll.options,
        votes={}
    )
    db.add(db_poll)
    db.commit()
    db.refresh(db_poll)
    return db_poll

@app.get("/clubs/{club_id}/polls/", response_model=List[PollOut])
def list_polls(club_id: int, db: Session = Depends(get_db)):
    polls = db.query(Poll).filter(Poll.club_id == club_id).order_by(Poll.created_at.desc()).all()
    return polls

@app.get("/polls/{poll_id}", response_model=PollOut)
def get_poll(poll_id: int, db: Session = Depends(get_db)):
    poll = db.query(Poll).filter(Poll.id == poll_id).first()
    if not poll:
        raise HTTPException(status_code=404, detail="Poll not found")
    return poll

@app.post("/polls/{poll_id}/vote")
def vote_poll(poll_id: int, vote: PollVote, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    poll = db.query(Poll).filter(Poll.id == poll_id).first()
    if not poll:
        raise HTTPException(status_code=404, detail="Poll not found")
    if vote.option not in poll.options:
        raise HTTPException(status_code=400, detail="Invalid option")
    # Check if user already voted
    for option_votes in poll.votes.values():
        if current_user.id in option_votes:
            raise HTTPException(status_code=400, detail="User already voted in this poll")
    # Add vote
    if vote.option not in poll.votes:
        poll.votes[vote.option] = []
    poll.votes[vote.option].append(current_user.id)
    db.commit()
    return {"detail": "Vote recorded successfully"}

@app.get("/polls/{poll_id}/results", response_model=PollResults)
def get_poll_results(poll_id: int, db: Session = Depends(get_db)):
    poll = db.query(Poll).filter(Poll.id == poll_id).first()
    if not poll:
        raise HTTPException(status_code=404, detail="Poll not found")
    # Calculate results
    total_votes = sum(len(votes) for votes in poll.votes.values())
    results = {option: len(poll.votes.get(option, [])) for option in poll.options}
    return PollResults(
        poll_id=poll.id,
        question=poll.question,
        options=poll.options,
        votes=poll.votes,
        total_votes=total_votes,
        results=results
    )


