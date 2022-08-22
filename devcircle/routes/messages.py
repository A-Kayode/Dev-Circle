from datetime import datetime
from flask import render_template, request, session, flash, redirect, jsonify
from .. import app
from ..models import *
from ..custom_functions import dev_validation


@app.route('/messages/ajax/retrievecorrespondence/')
@dev_validation
def retrieve_correspondence():
    did= session.get('dev_id')
    did2= request.args.get('dev_id')

    excor= Correspondence.query.filter(((Correspondence.dev_a == did)| (Correspondence.dev_b == did)), ((Correspondence.dev_a == did2)| (Correspondence.dev_b == did2))).first()
    if excor == None:
        addcor= Correspondence(dev_a=did, dev_b=did2)
        db.session.add(addcor)
        db.session.commit()
        return jsonify(status=1, message="No existing correspondence, new correspondence created", cid=addcor.cor_id)
    else:
        cormess= Messages.query.filter(Messages.corres_id == excor.cor_id).all()
        if cormess != []:
            allcor= []
            for m in cormess:
                m.status= "read"
                i=1 if m.sender == did else 0
                msg= [i, m.message, m.date_sent.strftime('%d %b, %Y at %H:%M')]
                allcor.append(msg)
            
            db.session.commit()

            return jsonify(status=2, message="There are messages in this correspondence", cid=excor.cor_id, allcor=allcor)
        else:
            return jsonify(status=3, message="There are no messages in this correspondence", cid=excor.cor_id)


@app.route('/messages/ajax/sendmessage/', methods=['POST', 'GET'])
@dev_validation
def send_message():
    sender= session.get('dev_id')
    cor_id= request.form.get('corres_id')
    message= request.form.get('message')

    mess= Messages(sender=sender, corres_id=cor_id, message=message)
    db.session.add(mess)
    db.session.commit()

    return jsonify(status=1, message="message sent")


@app.route('/messages/')
@dev_validation
def messages():
    did= session.get("dev_id")
    d= Developer.query.get(did)
    cor= Correspondence.query.filter((Correspondence.dev_a == did) | (Correspondence.dev_b == did)).all()

    #find the new messages that are linked to the correspondents of the developer
    if cor != []:
        mescount= []
        for i in cor:
            msc= Messages.query.filter(Messages.corres_id == i.cor_id, Messages.status == "new").count()
            mescount.append([i.cor_id, msc])
    
    #find all groups that user is part of and then extract all group members from those groups
    ag= Member.query.filter(Member.dev_id == did).all()
    allg= []
    if ag != []:
        for i in ag:
            allg.append(i.grp_id)
    allm= Member.query.filter(Member.grp_id.in_(allg)).all()

    return render_template('landing/messages.html', cor=cor, d=d, msc=mescount, allm=allm)