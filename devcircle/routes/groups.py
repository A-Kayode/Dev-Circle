from datetime import datetime
from flask import render_template, request, session, flash, redirect, jsonify, abort
from .. import app
from ..models import *
from ..custom_functions import dev_validation

@app.route('/groups/')
@dev_validation
def all_groups():
    did= session.get('dev_id')
    agrps= Member.query.filter(Member.dev_id == did, Member.status == "joined").all()
    lang= Language.query.all()

    totalmem= []
    for i in agrps:
        x= Member.query.filter(Member.grp_id == i.grp_id, Member.status == "joined").count()
        totalmem.append(x)
    
    #This is used to get group recommendations based on the languages chosen by the developer
    #getting the languages registered by the user
    dlo= db.session.execute(f"SELECT lang_id FROM dev_languages WHERE dev_id = '{did}'")
    dllt= dlo.fetchall()
    if dllt != []:
        dl= []
        for i in dllt:
            dl.append(i[0])
        dl= tuple(dl)
    #getting the groups that use any of the fetched languages
    if len(dl) == 1:
        glo= db.session.execute(f"SELECT grp_id FROM grp_languages WHERE lang_id = {dl[0]} GROUP BY grp_id")
    else:
        glo= db.session.execute(f"SELECT grp_id FROM grp_languages WHERE lang_id IN {dl} GROUP BY grp_id")
    glt= glo.fetchall()
    if glt != None:
        gl= []
        for i in glt:
            gl.append(i[0])
    #weeeding out the groups that the developer is already part of
    membership= Member.query.filter(Member.dev_id == did, Member.status == "joined").all()
    if membership != []:
        notgl= [i for i in gl]
        for o in gl:
            for i in membership:
                if i.grp_id == o:
                    notgl.remove(i.grp_id)
        notgl2= tuple(notgl)
    #get groups with the highest number of membership and limit to top 10 groups
    if len(notgl2) == 1:
        hgmo= db.session.execute(f"SELECT COUNT(grp_id) AS grp_no, grp_id FROM member WHERE grp_id = {notgl2[0]} AND status = 'joined' ORDER BY grp_no DESC LIMIT 10")
    else:
         hgmo= db.session.execute(f"SELECT COUNT(grp_id) AS grp_no, grp_id FROM member WHERE grp_id IN {notgl2} AND status = 'joined' ORDER BY grp_no DESC LIMIT 10")
    hgmr= hgmo.fetchall()
    print(hgmr)
    hgm= []
    if hgmr != [(0, None)]:
        for i in hgmr:
            hgm.append(i[1])
    #get the records of groups that pass this criteria
    rtotalmem= []
    if hgm != []:
        thgm= Group.query.filter(Group.grp_id.in_(hgm)).all()
        for i in thgm:
            y= Member.query.filter(Member.grp_id == i.grp_id, Member.status == "joined").count()
            rtotalmem.append(y)
    else:
        thgm= Group.query.filter(Group.grp_id.in_(notgl)).all()
        for i in thgm:
            y= Member.query.filter(Member.grp_id == i.grp_id, Member.status == "joined").count()
            rtotalmem.append(y)


    return render_template('landing/groups.html', agrps=agrps, tomem=totalmem, lang=lang, thgm=thgm, rtotalmem=rtotalmem)


@app.route('/groups/<int:gid>/')
@dev_validation
def specific_group(gid):
    did= session.get('dev_id')
    g= Group.query.get(gid)
    if g == None:
        abort(404)

    mem= Member.query.filter(Member.dev_id == did, Member.grp_id == gid, Member.status == "joined").first()
    if mem != None:
        memb= 1
        m= mem
        task= Task.query.filter(Task.from_mem == mem.mem_id, Task.status.in_(['pending', 'accepted', 'contended'])).count()
    else:
        memb= 0
        m=""
        task= 3
    
    posts= Post.query.filter(Post.grp_id == gid).order_by(Post.date_posted.desc()).all()
    
    allmems= Member.query.filter(Member.grp_id == gid, Member.dev_id != did, Member.status == "joined").all()
    avail_mems= Member.query.filter(Member.grp_id == gid, Member.task_availability == 'available', Member.dev_id != did, Member.status == "joined").all()

    am= Member.query.filter(Member.dev_id == did, Member.status == "joined").all()
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

    #retrieving all the rules of the group
    rule= Rule.query.filter(Rule.grp_id == gid).all()

    return render_template('landing/specific_group_page.html', g=g, memb=memb, m=m, posts=posts, availmems=avail_mems, allmems=allmems, t=t, contend=contend, rules=rule)


@app.route('/groups/ajax/joingroup/')
@dev_validation
def join_group():
    gid= request.args.get('grp_id')
    did= session.get('dev_id')
    try:
        chkmem= Member.query.filter(Member.grp_id == gid, Member.dev_id == did).first()
        if chkmem != None:
            chkmem.status = "joined"
        else:
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
        mem.status = "left"
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


@app.route('/groups/search/')
@dev_validation
def group_search():
    gname= request.args.get("group")
    #spliitting the group name inputted into a list of strings to act as keys
    grpkeys= gname.split()

    #getting the grooups that match the list of strings used as keys
    temagrps= []
    temagrpsname= []
    agrpname= []
    agrps= []
    #querying for records using the list of keys
    for i in grpkeys:
        x= Group.query.filter(Group.grp_name.like(f'%{i}%')).all()
        #appending each record into temagrps
        for j in x:
            temagrps.append(j)
    #ensuring that only unique records are put into agrps list
    for i in temagrps:
        temagrpsname.append(i.grp_name)
    for i in temagrpsname:
        if i not in agrpname:
            agrpname.append(i)
    for i in temagrps:
        for j in agrpname:
            if j == i.grp_name:
                agrps.append(i)

    
    #getting the total number of members in each group fetched
    totalmem= []
    for i in agrps:
        x= Member.query.filter(Member.grp_id == i.grp_id, Member.status == "joined").count()
        totalmem.append(x)

    return render_template('landing/search_group.html', agrps=agrps, tomem=totalmem, gname=gname)