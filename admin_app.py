from fastapi import FastAPI
from sqladmin import Admin, ModelView
from models import User, Club, Event, Membership, Registration, Post, Poll
from database import engine

app = FastAPI()

class UserAdmin(ModelView, model=User):
    column_list = [User.id, User.name, User.email, User.role]
    form_columns = ["name", "email", "role", "password"]  # Include password field

class ClubAdmin(ModelView, model=Club):
    column_list = [Club.id, Club.name, Club.author_id]

class EventAdmin(ModelView, model=Event):
    column_list = [Event.id, Event.name, Event.club_id, Event.date]

class MembershipAdmin(ModelView, model=Membership):
    column_list = [Membership.id, Membership.user_id, Membership.club_id, Membership.status]

class RegistrationAdmin(ModelView, model=Registration):
    column_list = [Registration.id, Registration.user_id, Registration.event_id, Registration.status, Registration.check_in]

class PostAdmin(ModelView, model=Post):
    column_list = [Post.id, Post.description, Post.club_id, Post.author_id, Post.created_at]

class PollAdmin(ModelView, model=Poll):
    column_list = [Poll.id, Poll.question, Poll.club_id, Poll.author_id, Poll.created_at]

admin = Admin(app, engine)
admin.add_view(UserAdmin)
admin.add_view(ClubAdmin)
admin.add_view(EventAdmin)
admin.add_view(MembershipAdmin)
admin.add_view(RegistrationAdmin)
admin.add_view(PostAdmin)
admin.add_view(PollAdmin)