import enum
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
    join_date= db.Column(db.DateTime())
    task_availablity= db.Column(db.Enum(Availability), default=Availability.available.name)

    group= db.relationship('Group', backref='members')
    developer= db.relationship('Developer', backref='groups')


class Post(db.Model):
    post_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    grp_id= db.Column(db.Integer(), db.ForeignKey('group.grp_id'))
    mem_id= db.Column(db.Integer(), db.ForeignKey('member.mem_id'))
    post= db.Column(db.Text(), nullable=False)


class Rule(db.Model):
    rule_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    grp_id= db.Column(db.Integer(), db.ForeignKey('group.grp_id'))
    rule= db.Column(db.Text(), nullable=False)

    group= db.relationship('Group', backref='rules')


class Task(db.Model):
    task_id= db.Column(db.Integer(), primary_key=True, autoincrement=True)
    grp_id= db.Column(db.Integer(), db.ForeignKey('group.grp_id'))
    from_mem= db.Column(db.Integer(), db.ForeignKey('member.mem_id'))
    to_mem= db.Column(db.Integer(), db.ForeignKey('member.mem_id'))
    task_desc= db.Column(db.Text(), nullable=False)
    deadline= db.Column(db.Date())

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