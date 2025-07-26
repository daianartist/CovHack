# main.py
from fastapi import FastAPI, Depends, HTTPException, Path
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from models import User, Base, Club, Event, Membership, Registration
from schemas import (
    PostCreate, PostOut, UserCreate, UserLogin, Token, ClubCreate, ClubOut, 
    EventCreate, EventOut, MembershipCreate, MembershipOut, RegistrationCreate, 
    RegistrationOut, UserOut, ForgotPasswordRequest, ResetPasswordRequest, 
    PollCreate, PollOut, PollVote, PollResults
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

app = FastAPI()

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
        range_name=club.range_name
    )
    db.add(db_club)
    db.commit()
    db.refresh(db_club)
    return db_club

@app.get("/clubs/", response_model=List[ClubOut])
def get_clubs(db: Session = Depends(get_db)):
    return db.query(Club).all()

@app.get("/clubs/{club_id}", response_model=ClubOut)
def get_club(club_id: int = Path(...), db: Session = Depends(get_db)):
    club = db.query(Club).filter(Club.id == club_id).first()
    if not club:
        raise HTTPException(status_code=404, detail="Club not found")
    return club

@app.put("/clubs/{club_id}", response_model=ClubOut)
def update_club(club_id: int, club: ClubCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_club = db.query(Club).filter(Club.id == club_id).first()
    if not db_club:
        raise HTTPException(status_code=404, detail="Club not found")
    if db_club.author_id != current_user.id and current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Not authorized to update this club")
    for key, value in club.dict().items():
        setattr(db_club, key, value)
    db.commit()
    db.refresh(db_club)
    return db_club

@app.delete("/clubs/{club_id}")
def delete_club(club_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_club = db.query(Club).filter(Club.id == club_id).first()
    if not db_club:
        raise HTTPException(status_code=404, detail="Club not found")
    if db_club.author_id != current_user.id and current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Not authorized to delete this club")
    db.delete(db_club)
    db.commit()
    return {"detail": "Club deleted"}

### **Events**

@app.post("/events/", response_model=EventOut)
def create_event(event: EventCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    db_club = db.query(Club).filter(Club.id == event.club_id).first()
    if not db_club:
        raise HTTPException(status_code=404, detail="Club not found")
    if db_club.author_id != current_user.id and current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Not authorized to create event for this club")
    db_event = Event(**event.dict())
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
    if db_club.author_id != current_user.id and current_user.role != "admin":
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
    if db_club.author_id != current_user.id and current_user.role != "admin":
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
    if club.author_id != current_user.id and current_user.role != "admin":
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
    if not club or (club.author_id != current_user.id and current_user.role != "admin"):
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
    if reset_codes.get(request.email) != request.code:
        raise HTTPException(status_code=400, detail="Invalid code")
    user = db.query(User).filter(User.email == request.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.password = hash_password(request.new_password)
    db.commit()
    reset_codes.pop(request.email, None)
    return {"detail": "Password reset successful"}

@app.post("/clubs/{club_id}/posts/", response_model=PostOut)
def create_post(club_id: int, post: PostCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    club = db.query(Club).filter(Club.id == club_id).first()
    if not club:
        raise HTTPException(status_code=404, detail="Club not found")
    # Only moderators of this club or admins can create
    if not (current_user.role == UserRole.admin or (current_user.role == UserRole.moderator and club.author_id == current_user.id)):
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
    if not (current_user.role == UserRole.admin or (current_user.role == UserRole.moderator and club.author_id == current_user.id)):
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
    if not (current_user.role == UserRole.admin or (current_user.role == UserRole.moderator and club.author_id == current_user.id)):
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
    if not (current_user.role == UserRole.admin or (current_user.role == UserRole.moderator and club.author_id == current_user.id)):
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
