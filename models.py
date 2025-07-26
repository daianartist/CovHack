from sqlalchemy import (
    Column, Integer, String, DateTime, ForeignKey, Enum, Boolean, Text, JSON
)
from sqlalchemy.orm import relationship, declarative_base
import enum
from datetime import datetime
from database import Base

class UserRole(enum.Enum):
    student = "student"
    moderator = "moderator"
    admin = "admin"

class MembershipStatus(enum.Enum):
    pending = "pending"
    approved = "approved"

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False, index=True)
    password = Column(String, nullable=False)
    role = Column(Enum(UserRole), default=UserRole.student, nullable=False)

    clubs = relationship("Membership", back_populates="user")
    events = relationship("Registration", back_populates="user")

class Club(Base):
    __tablename__ = "clubs"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    author_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    form_link = Column(String, nullable=True)
    sheet_id = Column(String, nullable=True)
    range_name = Column(String, nullable=True)
    questionnaire_url = Column(String, nullable=True)

    author = relationship("User")
    memberships = relationship("Membership", back_populates="club")
    events = relationship("Event", back_populates="club")
    posts = relationship("Post", back_populates="club")
    polls = relationship("Poll", back_populates="club")

class Event(Base):
    __tablename__ = "events"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    date = Column(DateTime, nullable=False)
    description = Column(Text)
    club_id = Column(Integer, ForeignKey("clubs.id"), nullable=False)
    points = Column(Integer, default=0)

    club = relationship("Club", back_populates="events")
    registrations = relationship("Registration", back_populates="event")

class Membership(Base):
    __tablename__ = "memberships"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    club_id = Column(Integer, ForeignKey("clubs.id"), nullable=False)
    status = Column(Enum(MembershipStatus), default=MembershipStatus.pending, nullable=False)

    user = relationship("User", back_populates="clubs")
    club = relationship("Club", back_populates="memberships")

class Registration(Base):
    __tablename__ = "registrations"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    event_id = Column(Integer, ForeignKey("events.id"), nullable=False)
    status = Column(String, nullable=False)
    check_in = Column(Boolean, default=False)

    user = relationship("User", back_populates="events")
    event = relationship("Event", back_populates="registrations")

class Post(Base):
    __tablename__ = "posts"
    id = Column(Integer, primary_key=True, index=True)
    club_id = Column(Integer, ForeignKey("clubs.id"), nullable=False)
    author_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    description = Column(Text, nullable=False)
    image_url = Column(String, nullable=True)
    event_id = Column(Integer, ForeignKey("events.id"), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    club = relationship("Club", back_populates="posts")
    author = relationship("User")
    event = relationship("Event")

class Poll(Base):
    __tablename__ = "polls"
    id = Column(Integer, primary_key=True, index=True)
    club_id = Column(Integer, ForeignKey("clubs.id"), nullable=False)
    author_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    question = Column(String, nullable=False)
    options = Column(JSON, nullable=False)  # List of strings
    votes = Column(JSON, nullable=False, default=dict)  # Dict: option -> list of user_ids
    created_at = Column(DateTime, default=datetime.utcnow)

    club = relationship("Club", back_populates="polls")
    author = relationship("User")
