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

    return render_template('landing/dev_page.html', dlang=dlang, dev=dev)


@app.route('/landing/ajax/savelanguages/', methods=['POST', 'GET'])
def save_languages():
    devlang= request.form.getlist('language')
    dev_id= request.form.get('dev_id')

    if devlang == []:
        return jsonify(status=0, message="You have to choose at least one language")

    try:
        for i in devlang:
            db.session.execute(f'INSERT INTO dev_languages SET dev_id = "{dev_id}", lang_id = "{i}"')
    except:
        db.session.rollback
        return jsonify(status=0, message="An error occured, please try again later")

    db.session.commit()

    tang= ",".join([str(o) for o in devlang])
    gl= db.session.execute(f"SELECT grp_id FROM grp_languages WHERE lang_id IN ({tang})")
    ggl= gl.fetchall()
    glang= [g.grp_id for g in ggl]
    gr= Group.query.filter(Group.grp_id.in_(glang), Group.grp_type == "public").all()
    grp_list= []
    for i in gr:
        b= [i.grp_name, i.grp_desc, i.grp_id]
        grp_list.append(b)
    
    return jsonify(status=1, message="Languages saved", glang=grp_list)


@app.route('/landing/ajax/getgroupinfo/')
@dev_validation
def get_group_info():
    did= session.get('dev_id')
    gid= request.args.get('grp_id')
    g= Group.query.get(gid)
    
    if g != None:
        info= [g.grp_id, g.grp_name, g.grp_desc, g.grp_type.name]

        r_obj= Rule.query.filter(Rule.grp_id == gid).all()
        if r_obj != []:
            rules= [r.rule for r in r_obj]
        else:
            rules= ["No rules found"]
        
        mem= Member.query.filter(Member.dev_id == did, Member.grp_id == gid).first()
        if mem != None:
            memb= 1
        else:
            memb=0
        
        return jsonify(status=1, message="Retrival successful", info=info, rules=rules, memb=memb)
    else:
        return jsonify(status=0, message="Something went wrong, try again later")