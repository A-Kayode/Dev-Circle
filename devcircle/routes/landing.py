from flask import render_template, request, session, flash, redirect, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
from .. import app
from ..models import *
from ..custom_functions import dev_validation


@app.route('/landing/')
@dev_validation
def dev_landing():
    dev_id= session.get('dev_id')
    dev= Developer.query.get(dev_id)
    lg= db.session.execute(f'SELECT lang_id FROM dev_languages WHERE dev_id = "{dev_id}"')
    dlang= lg.fetchall()

    m= Member.query.filter(Member.dev_id == dev_id, Member.status == "joined").all()
    memb=1
    
    grouplist= []
    for i in m:
        grouplist.append(i.grp_id)
    posts= Post.query.filter(Post.grp_id.in_(grouplist)).order_by(Post.date_posted.desc()).all()

    #retrieve all the languages available for rendering on the page if usser is new
    lang= Language.query.all()

    return render_template('landing/dev_page.html', dlang=dlang, dev=dev, m=m, posts=posts, memb=1, lang=lang)


@app.route('/logout/')
@dev_validation
def logout():
    session.pop('dev_id')
    return redirect('/')


@app.route('/me/')
@dev_validation
def me():
    did= session.get('dev_id')
    d= Developer.query.get(did)

    #retrieving all the languages that the user has selected
    dlo= db.session.execute(f"SELECT lang_id FROM dev_languages WHERE dev_id = {did};")
    dllt= dlo.fetchall()
    #converting records from list of tuples to just a normal list
    dl= []
    if dllt != []:
        for i in dllt:
            dl.append(i[0])
    
    #retrieving all languages
    lang= Language.query.all()


    return render_template('landing/me.html', d=d, dl=dl, lang=lang)


@app.route('/me/ajax/changeusername/', methods=['POST', 'GET'])
@dev_validation
def change_username():
    uname= request.form.get('username')
    did= session.get('dev_id')

    #retrieve the record and change it's username record
    d= Developer.query.get(did)
    d.username= uname
    db.session.commit()

    return jsonify(status=1)


@app.route('/me/ajax/changepassword/', methods=['POST', 'GET'])
@dev_validation
def change_password():
    oldpass= request.form.get('old_pswd')
    newpass= request.form.get('new_pswd')
    cnewpass= request.form.get('cnew_pswd')
    did= session.get("dev_id")

    #retrive the password hash of the old password and check agains what is inputted
    d= Developer.query.get(did)
    if check_password_hash(d.password, oldpass):
        #check whether new passwords are the same
        if newpass == cnewpass:
            phash= generate_password_hash(newpass)
            d.password= phash
            db.session.commit()

            return jsonify(status=1)
        else:
            return jsonify(status=0)
    else:
        return jsonify(status=0)