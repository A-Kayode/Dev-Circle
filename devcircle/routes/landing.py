from flask import render_template, request, session, flash, redirect, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
from .. import app
from ..forms import Signup
from ..models import *

@app.route('/')
def landing():
    return render_template('landing/index.html', Signup=Signup())


@app.route('/signup/', methods=['POST'])
def signup():
    sign= Signup()
    if sign.validate_on_submit():
        fname= request.form.get('fname')
        lname= request.form.get('lname')
        email= request.form.get('email')
        username= request.form.get('username')
        password= request.form.get('password')
        hashpass= generate_password_hash(password)

        dev= Developer(fname=fname, lname=lname, username=username, email=email, password=hashpass)
        db.session.add(dev)
        db.session.commit()

        session['dev_id']= dev.dev_id

        return f"{fname} {lname} {email} {username} {password}"
    else:
        return render_template('landing/index.html', Signup=sign)


@app.route('/ajax/validatelogin/', methods=['POST'])
def validate_login():
    username= request.form.get('username')
    password= request.form.get('password')

    dev= Developer.query.filter(Developer.username == username).first()
    if dev != None and check_password_hash(dev.password, password):
        return jsonify(status=1, message='Credentials Correct')
    else:
        return jsonify(status=0, message="Invalid Credentials")


@app.route('/login/', methods=['POST'])
def login():
    username= request.form.get('username')
    d= Developer.query.filter(Developer.username == username).first()
    session['dev_id']= d.dev_id
    return "Welcome"