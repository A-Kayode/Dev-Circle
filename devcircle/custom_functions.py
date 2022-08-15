from functools import wraps
from flask import redirect, session, flash

def dev_validation(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        if session.get('dev_id') != None:
            return func(*args, **kwargs)
        else:
            flash("You have to login first")
            return redirect('/')
    return wrapper