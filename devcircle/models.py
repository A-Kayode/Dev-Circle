import enum
from datetime import date, timedelta
from sqlalchemy import ForeignKey, func
from . import db

class Group_type(enum.Enum):
    private= "Private Group"
    public= "Public Group"

class Is_admin(enum.Enum):
    yes= "Is admin"
    no= "Is not admin"

class Availability(enum.Enum):
    available= "Is available"
    unavailable= "Is not available"

class Fine_status(enum.Enum):
    paid= "fine paid"
    unpaid= "fine not paid"

class Payment_status(enum.Enum):
    successful= "payment successful"
    unsuccessful= "payment not successful"

class Task_status(enum.Enum):
    accepted= "task accepted"
    contended= "task being contended"
    pending= "acceptance pending"
    expired= "task expired"
    completed= "task complete"
    late= 'task submission late'
    submitted= "task submitted"
    cancelled= "task cancelled due to contention"

class Contention_state(enum.Enum):
    active= 'voting open'
    succeeded= 'contention passed, project cancelled'
    failed= 'contention failed, project remains'

class Votes(enum.Enum):
    yes= "agree"
    no= "disagree"

class Message_status(enum.Enum):
    new= "new message"
    read= "read message"




dev_languages= db.Table(
    'dev_languages',
    db.Column('dev_id', db.Integer(), db.ForeignKey('developer.dev_id')),
    db.Column('lang_id', db.Integer(), db.ForeignKey('language.lang_id'))
)

grp_languages= db.Table(
    'grp_languages',
    db.Column('grp_id', db.Integer(), db.ForeignKey('group.grp_id')),
    db.Column('lang_id', db.Integer(), db.ForeignKey('language.lang_id'))
)




class Developer(db.Model):
    dev_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    fname= db.Column(db.String(255), nullable=False)
    lname= db.Column(db.String(255), nullable=False)
    email= db.Column(db.String(255), nullable=False)
    username= db.Column(db.String(255), nullable=False, unique=True)
    password= db.Column(db.String(255), nullable=False)
    regdate= db.Column(db.DateTime(), nullable=False, default= func.now())

    languages= db.relationship('Language', secondary=dev_languages, lazy='subquery', backref=db.backref('developers', lazy=True))


class Language(db.Model):
    lang_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    lang_name= db.Column(db.String(255), nullable=False, unique=True)


class Group(db.Model):
    grp_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    grp_name= db.Column(db.String(255), nullable=False, unique=True)
    grp_desc= db.Column(db.Text())
    grp_type= db.Column(db.Enum(Group_type), nullable=False)

    languages= db.relationship('Language', secondary= grp_languages, lazy='subquery', backref=db.backref('groups', lazy=True))


class Member(db.Model):
    mem_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    grp_id= db.Column(db.Integer(), db.ForeignKey('group.grp_id'))
    dev_id= db.Column(db.Integer(), db.ForeignKey('developer.dev_id'))
    admin= db.Column(db.Enum(Is_admin), default=Is_admin.no.name)
    join_date= db.Column(db.DateTime(), default=func.now())
    task_availability= db.Column(db.Enum(Availability), default=Availability.available.name)

    group= db.relationship('Group', backref='members')
    developer= db.relationship('Developer', backref='groups')


class Post(db.Model):
    post_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    grp_id= db.Column(db.Integer(), db.ForeignKey('group.grp_id'))
    mem_id= db.Column(db.Integer(), db.ForeignKey('member.mem_id'))
    post= db.Column(db.Text(), nullable=False)
    title= db.Column(db.String(255), nullable=False, default="")
    date_posted= db.Column(db.DateTime(), nullable=False, default=func.now())
    date_edited= db.Column(db.DateTime(), nullable=False, default="", onupdate=func.now())

    poster= db.relationship('Member', backref='posts')
    group= db.relationship('Group', backref='posts')


class Rule(db.Model):
    rule_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    grp_id= db.Column(db.Integer(), db.ForeignKey('group.grp_id'))
    rule= db.Column(db.Text(), nullable=False)

    group= db.relationship('Group', backref='rules')


class Task(db.Model):
    task_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    grp_id= db.Column(db.Integer(), db.ForeignKey('group.grp_id'), nullable=False)
    from_mem= db.Column(db.Integer(), db.ForeignKey('member.mem_id'), nullable=False)
    to_mem= db.Column(db.Integer(), db.ForeignKey('member.mem_id'), nullable=False)
    task_title= db.Column(db.String(255), nullable=False)
    task_desc= db.Column(db.Text(), nullable=False)
    status= db.Column(db.Enum(Task_status), default= Task_status.pending.name)
    deadline= db.Column(db.Date())
    duration= db.Column(db.Integer(), nullable=False)
    date_assigned= db.Column(db.Date(), nullable=False, default=func.now())

    assigner= db.relationship('Member', backref='tasks_assigned', foreign_keys=[from_mem])
    assignee= db.relationship('Member', backref='assigned_tasks', foreign_keys=[to_mem])
    group= db.relationship('Group', backref='tasks')


class Fine(db.Model):
    fine_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    mem_id= db.Column(db.Integer(), db.ForeignKey('member.mem_id'))
    amount= db.Column(db.Float())
    status= db.Column(db.Enum(Fine_status), nullable=False, default=Fine_status.unpaid.name)
    deadline= db.Column(db.Date())

    offender= db.relationship('Member', backref='fines')


class Payment(db.Model):
    pay_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    fine_id= db.Column(db.Integer(), db.ForeignKey('fine.fine_id'))
    pay_reference= db.Column(db.String(255), nullable=False)
    pay_status= db.Column(db.Enum(Payment_status))


class Contention(db.Model):
    con_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    task_id= db.Column(db.Integer(), db.ForeignKey('task.task_id'))
    state= db.Column(db.Enum(Contention_state), default=Contention_state.active.name)
    closing_date= db.Column(db.Date(), default=date.today()+timedelta(days=3))

    task= db.relationship('Task', backref="contended")


class Con_votes(db.Model):
    vote_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    issue_id= db.Column(db.Integer(), db.ForeignKey('contention.con_id'))
    voter= db.Column(db.Integer(), db.ForeignKey('member.mem_id'))
    vote= db.Column(db.Enum(Votes), nullable=False)

    issue= db.relationship('Contention', backref='votes')


class Submitted_projects(db.Model):
    sub_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    task_id= db.Column(db.Integer(), db.ForeignKey('task.task_id'))
    github= db.Column(db.String(255), nullable=False)
    url= db.Column(db.String(255))

    task_details= db.relationship('Task', backref='submitted_projects')


class Messages(db.Model):
    message_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    sender= db.Column(db.Integer(), db.ForeignKey('developer.dev_id'))
    corres_id= db.Column(db.Integer(), db.ForeignKey('correspondence.cor_id'))
    message= db.Column(db.Text())
    date_sent= db.Column(db.DateTime(), nullable=False, default=func.now())
    status= db.Column(db.Enum(Message_status), default=Message_status.new.name)

    correspondents= db.relationship('Correspondence', backref="messages")
    sender_details= db.relationship('Developer', backref="messages_sent")


class Correspondence(db.Model):
    cor_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    dev_a= db.Column(db.Integer(), db.ForeignKey('developer.dev_id'), nullable=False)
    dev_b= db.Column(db.Integer(), db.ForeignKey('developer.dev_id'), nullable=False)

    first_dev= db.relationship('Developer', backref='correspondence_1', foreign_keys=[dev_a])
    second_dev= db.relationship('Developer', backref='correspondence_2', foreign_keys=[dev_b])