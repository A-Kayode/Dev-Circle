from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField
from wtforms.validators import DataRequired, Length, Email

class Signup(FlaskForm):
    username= StringField(validators=[DataRequired(message="Input is required")])
    fname= StringField(validators=[DataRequired(message="Input is required")])
    lname= StringField(validators=[DataRequired(message="Input is required")])
    email= StringField(validators=[DataRequired(message="Input is required"), Email(message="Not a valid email address")])
    password= PasswordField(validators=[Length(message="Password must be up to 8 characters", min=8)])