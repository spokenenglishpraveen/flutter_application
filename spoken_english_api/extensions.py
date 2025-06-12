from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt

# Global instances (used across all files)
db = SQLAlchemy()
bcrypt = Bcrypt()
