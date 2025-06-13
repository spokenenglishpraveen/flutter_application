from datetime import datetime
from spoken_english_api.extensions import db

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(150), unique=True)
    phone = db.Column(db.String(15), unique=True)
    password_hash = db.Column(db.String(128))
    name = db.Column(db.String(100))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
