from datetime import datetime, timedelta, date
from flask import render_template, request, session, flash, redirect, jsonify
from .. import app, scheduler
from ..models import *
from ..custom_functions import dev_validation


#scheduled tasks
@scheduler.task('interval', id='contention_check', hours=12, start_date=datetime.now())
def contention_check():
    #retrieve all contentions
    cont= Contention.query.filter(Contention.state == "active").all()
    if cont != []:
        #check for contentions that have closed
        for i in cont:
            if i.closing_date < date.today():
                #check the number of yes and no votes and compare them
                yv= Con_votes.query.filter(Con_votes.issue_id == i.con_id, Con_votes.vote == "yes").count()
                nv= Con_votes.query.filter(Con_votes.issue_id == i.con_id, Con_votes.vote == "no").count()
                #activate or cancel project depending on ratio of yes and no votes
                if nv > yv:
                    i.state= "succeeded"
                    i.task.status= "cancelled"
                    dev= i.task.assignee.dev_id
                    mem= Member.query.filter(Member.dev_id == dev).all()
                    for j in mem:
                        j.task_availability= "available"
                    db.session.commit()
                else:
                    i.state= "failed"
                    i.task.status= "accepted"
                    i.task.deadline= date.today() + timedelta(days=i.task.duration)
                    db.session.commit()





#routes
@app.route('/projects/ajax/assignproject/', methods=['POST', 'GET'])
@dev_validation
def assign_project():
    gid= request.form.get('grp_id')
    fmem= request.form.get('from')
    tmem= request.form.get('to')
    p_title= request.form.get('title')
    p_desc= request.form.get('desc')
    tdur= request.form.get('dur')
    dur= int(tdur)
    tm= Member.query.get(tmem)
    tmdet= tm.developer.username
    tdid= tm.dev_id


    try:
        t= Task(grp_id=gid, from_mem=fmem, to_mem=tmem, task_title=p_title, task_desc=p_desc, duration=dur)
        db.session.add(t)

        alm= Member.query.filter(Member.dev_id ==tdid).all()
        for i in alm:
            i.task_availability= "unavailable"
    except:
        db.session.rollback()
        return jsonify(status=0, message="An error occured. Please try again later.")
    db.session.commit()


    return jsonify(status=1, message=f"Project has been assigned successfully to {tmdet}")


@app.route('/projects/')
@dev_validation
def projects():
    did= session.get('dev_id')

    m= Member.query.filter(Member.dev_id == did).all()
    mem= []
    if m != []:
        for i in m:
            mem.append(i.mem_id)

    ass= Task.query.filter(Task.to_mem.in_(mem), Task.status.in_(['pending', 'accepted', 'contended', 'late'])).all()
    com= Task.query.filter(Task.to_mem.in_(mem), Task.status.in_(['expired', 'completed', 'cancelled'])).order_by(Task.date_assigned.desc()).all()
    pas= Task.query.filter(Task.from_mem.in_(mem)).order_by(Task.date_assigned.desc()).all()
    pas2= Task.query.filter(Task.from_mem.in_(mem), Task.status == "completed").all()

    #this will pick out the the details of the submitted projects
    sub= []
    for i in com:
        if i.status.name == "completed":
            s= Submitted_projects.query.filter(Submitted_projects.task_id == i.task_id).first()
            sub.append(s)
    for i in pas2:
        if i.status.name == "completed":
            s2= Submitted_projects.query.filter(Submitted_projects.task_id == i.task_id).first()
            sub.append(s2)

    return render_template('landing/projects.html', ass=ass, com=com, pas=pas, sub=sub)


@app.route('/projects/ajax/acceptproject/', methods=['POST', 'GET'])
@dev_validation
def accept_project():
    tid= request.form.get('task_id')
    try:
        task= Task.query.get(tid)
        task.status= 'accepted'
        task.deadline= date.today() + timedelta(days=task.duration)
    except:
        db.session.rollback()
        return jsonify(status=0, message="An error occured. Please try again later")
    db.session.commit()

    return jsonify(status=1, message="Done", deadline=task.deadline.strftime("%d %b, %Y"))


@app.route('/projects/ajax/cancelproject/', methods=['POST', 'GET'])
@dev_validation
def cancel_project():
    tid= request.form.get('task_id')
    try:
        task= Task.query.get(tid)
        task.status= 'cancelled'
        adid= task.assignee.dev_id
        am= Member.query.filter(Member.dev_id == adid).all()
        for i in am:
            i.task_availability= "available"
    except:
        db.session.rollback()
        return jsonify(status=0, message="An error occured. Please try again later")
    db.session.commit()

    return jsonify(status=1, message="Done")


@app.route('/projects/ajax/contendproject/', methods=['POST', 'GET'])
@dev_validation
def contend_project():
    tid= request.form.get('task_id')
    try:
        task= Task.query.get(tid)
        task.status= 'contended'
        c= Contention(task_id=tid)
        db.session.add(c)
    except:
        db.session.rollback()
        return jsonify(status=0, message="An error occured. Please try again later.")
    db.session.commit()

    return jsonify(status=1, message="This project will be contended.")


@app.route('/projects/ajax/getcontentioninfo/')
@dev_validation
def get_contention_info():
    tid= request.args.get('task_id')
    try:
        t= Task.query.get(tid)
        c= Contention.query.filter(Contention.task_id == tid).first()
    except:
        return jsonify(status=0, message="An error occured. Please try again later")
    task= [t.assigner.developer.username, t.assignee.developer.username, t.task_title, t.task_desc, t.duration, c.con_id]
    
    return jsonify(status=1, message="done", task=task)


@app.route('/projects/ajax/voteoncontention/', methods=['POST', 'GET'])
@dev_validation
def vote_on_contention():
    cid= request.form.get('contend_id')
    vote= request.form.get('vote')
    vid= request.form.get('voter')
    
    try:
        c= Contention.query.get(cid)
        fm= c.task.from_mem
        tm= c.task.to_mem
        if vid == fm or vid == tm:
            return jsonify(status=0, message="Vote cannot be cast votes on a project you assigned or were assigned.")
        else:
            mv= Con_votes.query.filter(Con_votes.issue_id == cid, Con_votes.voter == vid).first()
            if mv != None:
                return jsonify(status=0, message="You cannot vote multiple times on the same contested project.")
            else:
                v= Con_votes(issue_id=cid, voter=vid, vote=vote)
                db.session.add(v)
    except:
        db.session.rollback()
        return jsonify(status=0, message="An error occured. Please try again later.")
    
    db.session.commit()

    try:
        tv= Con_votes.query.filter(Con_votes.issue_id == cid).count()
        yv= Con_votes.query.filter(Con_votes.issue_id == cid, Con_votes.vote == 'yes').count()
        nv= Con_votes.query.filter(Con_votes.issue_id == cid, Con_votes.vote == 'no').count()
    except:
        return jsonify(status=1, message="An error occured. Your vote has been cast but voting results could not be retrieved.")

    return jsonify(status=2, message="Your vote has been cast.", tv=tv, yv=yv, nv=nv)


@app.route('/projects/ajax/submit_project/', methods=['POST', 'GET'])
@dev_validation
def submit_project():
    github= request.form.get('git_link')
    url_link= request.form.get('url_link')
    tid= request.form.get('task_id')

    try:
        sp= Submitted_projects(task_id=tid, github=github, url=url_link)
        db.session.add(sp)
        tk= Task.query.get(tid)
        if tk.group.grp_type.name == "public":
            tk.status= "completed"

            adid= tk.assignee.dev_id
            am= Member.query.filter(Member.dev_id == adid).all()
            for i in am:
                i.task_availability= "available"
        elif tk.group.grp_type.name == "private":
            tk.status= "submitted"
    except:
        db.session.rollback()
        return jsonify(status=0, message="An error occured. Please try again later.")

    db.session.commit()

    return jsonify(status=1, message="Project submitted successfully")
