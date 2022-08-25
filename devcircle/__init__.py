from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_wtf.csrf import CSRFProtect
from flask_apscheduler import APScheduler

app= Flask(__name__)
app.config.from_pyfile('config.py')
db= SQLAlchemy(app)
csrf= CSRFProtect(app)
migrate= Migrate(app, db)
scheduler= APScheduler()
scheduler.init_app(app)
scheduler.start()

from .routes import index, landing, groups, utility, projects, messages
from . import models