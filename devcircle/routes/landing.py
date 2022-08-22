from flask import render_template, request, session, flash, redirect, jsonify
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

    m= Member.query.filter(Member.dev_id == dev_id).all()
    
    grouplist= []
    for i in m:
        grouplist.append(i.grp_id)
    posts= Post.query.filter(Post.grp_id.in_(grouplist)).order_by(Post.date_posted.desc()).all()

    return render_template('landing/dev_page.html', dlang=dlang, dev=dev, m=m, posts=posts)


@app.route('/logout/')
@dev_validation
def logout():
    session.pop('dev_id')
    return redirect('/')