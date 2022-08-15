from flask import render_template, request, session, flash, redirect, jsonify
from .. import app
from ..models import *
from ..custom_functions import dev_validation

@app.route('/groups/')
@dev_validation
def all_groups():
    return "This is the groups page"

@app.route('/groups/<int:gid>/')
@dev_validation
def group(gid):
    g= Group.query.get(gid)
    return render_template('landing/group_page.html', g=g)


@app.route('/groups/ajax/joingroup/')
@dev_validation
def join_group():
    gid= request.args.get('grp_id')
    did= session.get('dev_id')
    try:
        mem= Member(dev_id=did, grp_id=gid)
        db.session.add(mem)
    except:
        db.session.rollback()
        return jsonify(status=0, message="An error occurred. Please try again later")
    db.session.commit()

    return jsonify(status=1, message="Group Joined")


@app.route('/groups/ajax/leavegroup/')
@dev_validation
def leave_group():
    did= session.get('dev_id')
    gid= request.args.get('grp_id')
    try:
        mem= Member.query.filter(Member.dev_id == did, Member.grp_id == gid).first()
        db.session.delete(mem)
    except:
        db.session.rollback
        return jsonify(status=0, message="An error occurred. Please try again later")
    db.session.commit()

    return jsonify(status=1, message="Group Left")