from flask import Blueprint, request, jsonify
from datetime import datetime
import random
from sqlalchemy import or_
from spoken_english_api.extensions import db, bcrypt
from spoken_english_api.app.models import User
auth_bp = Blueprint('auth', __name__)
from flask_jwt_extended import jwt_required, get_jwt_identity, create_access_token


# Temporary OTP storage (development only – replace with Redis or DB in production)
otp_storage = {}

# ---------------- SIGN UP ----------------
@auth_bp.route('/signup', methods=['POST'])
def signup():
    data = request.get_json()
    email = data.get("email")
    phone = data.get("phone")
    password = data.get("password")
    name = data.get("name")

    if not (email or phone):
        return jsonify({"error": "Email or phone required"}), 400
    if not password:
        return jsonify({"error": "Password required"}), 400

    if email and User.query.filter_by(email=email).first():
        return jsonify({"error": "Email already registered"}), 400
    if phone and User.query.filter_by(phone=phone).first():
        return jsonify({"error": "Phone already registered"}), 400

    hashed_pw = bcrypt.generate_password_hash(password).decode("utf-8")
    user = User(email=email, phone=phone, password_hash=hashed_pw, name=name)
    db.session.add(user)
    db.session.commit()

    access_token = create_access_token(identity=user.id)
    return jsonify({
        "message": "User created",
        "access_token": access_token,
        "user": {"name": user.name, "email": user.email, "phone": user.phone}
    }), 201

# ---------------- LOGIN ----------------
@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    identifier = data.get("email") or data.get("phone")
    password = data.get("password")

    if not identifier or not password:
        return jsonify({"error": "Email/Phone and password required"}), 400

    user = User.query.filter(or_(User.email == identifier, User.phone == identifier)).first()

    if user and user.password_hash and bcrypt.check_password_hash(user.password_hash, password):
        access_token = create_access_token(identity=user.id)
        return jsonify({
            "message": "Login successful",
            "access_token": access_token,
            "user": {"name": user.name, "email": user.email, "phone": user.phone}
        })
    return jsonify({"error": "Invalid credentials"}), 401

# ---------------- SEND OTP ----------------
@auth_bp.route('/send-otp', methods=['POST'])
def send_otp():
    data = request.get_json()
    phone = data.get("phone")
    if not phone:
        return jsonify({"error": "Phone required"}), 400

    otp = str(random.randint(100000, 999999))
    otp_storage[phone] = otp
    print(f"[DEBUG] OTP for {phone}: {otp}")
    return jsonify({"message": "OTP sent"})

# ---------------- VERIFY OTP ----------------
@auth_bp.route('/verify-otp', methods=['POST'])
def verify_otp():
    data = request.get_json()
    phone = data.get("phone")
    otp = data.get("otp")

    if otp_storage.get(phone) == otp:
        user = User.query.filter_by(phone=phone).first()
        if not user:
            user = User(phone=phone, name="New User")
            db.session.add(user)
            db.session.commit()

        access_token = create_access_token(identity=user.id)
        return jsonify({
            "message": "OTP verified",
            "access_token": access_token,
            "user": {"name": user.name, "phone": user.phone}
        })
    return jsonify({"error": "Invalid OTP"}), 401

# ---------------- CURRENT USER PROFILE ----------------
@auth_bp.route('/me', methods=['GET'])
@jwt_required()
def get_current_user():
    user_id = get_jwt_identity()
    user = User.query.get(user_id)
    if not user:
        return jsonify({'error': 'User not found'}), 404
    return jsonify({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'phone': user.phone
    })
