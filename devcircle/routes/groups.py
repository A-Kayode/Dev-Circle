from datetime import datetime
from flask import render_template, request, session, flash, redirect, jsonify, abort
from .. import app
from ..models import *
from ..custom_functions import dev_validation

@app.route('/groups/')
@dev_validation
def all_groups():
    did= session.get('dev_id')
    agrps= Member.query.filter(Member.dev_id == did).all()
    lang= Language.query.all()

    tomem= []
    for i in agrps:
        x= Member.query.filter(Member.grp_id == i.grp_id).count()
        tomem.append(x)

    return render_template('landing/groups.html', agrps=agrps, tomem=tomem, lang=lang)


@app.route('/groups/<int:gid>/')
@dev_validation
def specific_group(gid):
    did= session.get('dev_id')
    g= Group.query.get(gid)
    if g == None:
        abort(404)

    mem= Member.query.filter(Member.dev_id == did, Member.grp_id == gid).first()
    if mem != None:
        memb= 1
        m= mem
        task= Task.query.filter(Task.from_mem == mem.mem_id, Task.status.in_(['pending', 'accepted', 'contended'])).count()
    else:
        memb= 0
        m=""
        task= 3
    
    posts= Post.query.filter(Post.grp_id == gid).order_by(Post.date_posted.desc()).all()
    
    allmems= Member.query.filter(Member.grp_id == gid, Member.dev_id != did).all()
    avail_mems= Member.query.filter(Member.grp_id == gid, Member.task_availability == 'available', Member.dev_id != did).all()

    am= Member.query.filter(Member.dev_id == did).all()
    amem= []
    if am != []:
        for i in am:
            amem.append(i.mem_id)

    atask= Task.query.filter(Task.from_mem.in_(amem), Task.status.in_(['pending', 'accepted', 'contended'])).count()
    if task > 2 or atask > 5:
        t= False
    else:
        t= True

    #code to trieve contended projects in the particular group
    contend= Task.query.filter(Task.grp_id == gid, Task.status == 'contended').all()

    return render_template('landing/specific_group_page.html', g=g, memb=memb, m=m, posts=posts, availmems=avail_mems, allmems=allmems, t=t, contend=contend)


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


@app.route('/groups/creategroup/', methods=['POST'])
@dev_validation
def create_group():
    did= session.get('dev_id')
    gname= request.form.get('group_name')
    gtype= request.form.get('group_type')
    glang= request.form.getlist('group_languages')
    gdesc= request.form.get('group_description')
    grule= request.form.getlist('group_rule')

    #creating new group
    new_group= Group(grp_name=gname, grp_type=gtype, grp_desc=gdesc)
    db.session.add(new_group)
    db.session.commit()
    ngid= new_group.grp_id

    #adding languages to the group
    if glang != []:
        lang_query= ""
        for i in glang:
            db.session.execute(f"INSERT INTO grp_languages (grp_id, lang_id) VALUES ('{ngid}', '{i}')")
        db.session.commit()

    #adding rules for the group
    if grule != []:
        ruleobjs= []
        for i in grule:
            ob= Rule(grp_id=ngid, rule=i)
            ruleobjs.append(ob)
        db.session.add_all(ruleobjs)
        db.session.commit()
    
    #adding the developer that created the group to be a member of the group
    mem= Member(grp_id=ngid, dev_id=did, admin="yes")
    db.session.add(mem)
    db.session.commit()
    
    return redirect(f'/groups/{ngid}/')
            


@app.route('/groups/ajax/checkgroupname/')
@dev_validation
def check_group_name():
    gname= request.args.get('gname')
    ag= Group.query.filter(Group.grp_name == gname).first()
    if ag != None:
        return jsonify(status=0)
    else:
        return jsonify(status=1)