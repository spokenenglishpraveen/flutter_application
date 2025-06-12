from flask import Flask, jsonify, request, Blueprint
from flask_cors import CORS
from dotenv import load_dotenv
import os
import random
from flask_jwt_extended import JWTManager, jwt_required, get_jwt_identity

# ✅ This is the correct path from the app root
from app.models.user import User

# ✅ Load environment variables
load_dotenv()

# ✅ Relative to spoken_english_api root
from extensions import db, bcrypt
from data.verbs_data import verbs_dict
from data.vocabulary_data import vocab_dict
from data.tenses_data import tenses

# ✅ Relative to spoken_english_api root
from app.routes.auth_bp import auth_bp


# Import auth blueprint
from spoken_english_api.app.routes.auth_bp import auth_bp

# Prepare data lists
vocabulary = list(vocab_dict.values())
verbs = list(verbs_dict.values())

# Blueprint for practice-related routes
practice_bp = Blueprint('practice', __name__)

# ---------------- TENSES ----------------
@practice_bp.route('/tenses-list', methods=['GET'])
def get_tense_list():
    return jsonify(list(tenses.keys()))

@practice_bp.route('/tenses/<tense>', methods=['GET'])
def get_tense_data(tense):
    data = tenses.get(tense)
    if not data:
        return jsonify({"error": "Tense not found"}), 404
    return jsonify([{"telugu": t[0], "english": t[1]} for t in data])

@practice_bp.route('/tenses/practice', methods=['GET'])
def get_random_tense_sentence():
    tense = request.args.get('tense')
    data = tenses.get(tense)
    if not data:
        return jsonify({"error": "Tense not found"}), 404
    sentence = random.choice(data)
    return jsonify({"telugu": sentence[0], "english": sentence[1]})

@practice_bp.route('/tenses/check', methods=['POST'])
def check_tense_sentence():
    data = request.json
    telugu = data.get('telugu_sentence')
    user_input = data.get('user_translation', '').strip().lower()
    for sentence_list in tenses.values():
        match = next((s for s in sentence_list if s[0] == telugu), None)
        if match:
            return jsonify({"correct": user_input == match[1].strip().lower()})
    return jsonify({"error": "Sentence not found"}), 404

@practice_bp.route('/tenses/answer', methods=['GET'])
def get_tense_answer():
    telugu = request.args.get('telugu')
    for sentence_list in tenses.values():
        match = next((s for s in sentence_list if s[0] == telugu), None)
        if match:
            return jsonify({"telugu": match[0], "english": match[1]})
    return jsonify({"error": "Sentence not found"}), 404

# ---------------- VERBS ----------------
@practice_bp.route('/verbs', methods=['GET'])
def get_verbs():
    level_param = request.args.get('level')
    if level_param:
        try:
            level = int(level_param)
            filtered_verbs = [verb for verb in verbs if verb.get('level') == level]
            return jsonify(filtered_verbs)
        except ValueError:
            return jsonify({"error": "Invalid level parameter"}), 400
    return jsonify(verbs)

@practice_bp.route('/verbs/random', methods=['GET'])
def get_random_verb():
    level_param = request.args.get('level')
    try:
        if level_param:
            level = int(level_param)
            filtered_verbs = [verb for verb in verbs if verb.get('level') == level]
            if not filtered_verbs:
                return jsonify({"error": "No verbs found for this level"}), 404
            return jsonify(random.choice(filtered_verbs))
        return jsonify(random.choice(verbs))
    except ValueError:
        return jsonify({"error": "Invalid level parameter"}), 400

# ---------------- VOCABULARY ----------------
@practice_bp.route('/vocabulary', methods=['GET'])
def get_vocabulary():
    level_param = request.args.get('level')
    if level_param:
        try:
            level = int(level_param)
            filtered_vocab = [word for word in vocabulary if word.get('level') == level]
            return jsonify(filtered_vocab)
        except ValueError:
            return jsonify({"error": "Invalid level parameter"}), 400
    return jsonify(vocabulary)

@practice_bp.route('/vocabulary/random', methods=['GET'])
def get_random_vocabulary_word():
    level_param = request.args.get('level')
    try:
        if level_param:
            level = int(level_param)
            filtered_vocab = [word for word in vocabulary if word.get('level') == level]
            if not filtered_vocab:
                return jsonify({"error": "No vocabulary found for this level"}), 404
            word = random.choice(filtered_vocab)
        else:
            word = random.choice(vocabulary)
        return jsonify(word)
    except ValueError:
        return jsonify({"error": "Invalid level parameter"}), 400

@practice_bp.route('/vocabulary/answer', methods=['GET'])
def get_vocabulary_answer():
    telugu_word = request.args.get('telugu', '').strip()
    if not telugu_word:
        return jsonify({"error": "Missing 'telugu' parameter"}), 400
    match = next((word for word in vocabulary if word.get("telugu_meaning", "").strip() == telugu_word), None)
    if match:
        return jsonify(match)
    return jsonify({"error": "Word not found"}), 404

# ---------------- HEALTH ----------------
@practice_bp.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "ok"})

# ---------------- APP FACTORY ----------------
def create_app():
    app = Flask(__name__)

    # Config setup
    app.config['SECRET_KEY'] = os.getenv("SECRET_KEY")
    app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv("DATABASE_URL")
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['JWT_SECRET_KEY'] = os.getenv("JWT_SECRET_KEY", "super-secret")

    # Enable CORS
    CORS(app, resources={r"/*": {
    "origins": ["https://spokenenglishpraveen.github.io"]}}, supports_credentials=True)


    # Init extensions
    db.init_app(app)
    bcrypt.init_app(app)
    jwt = JWTManager(app)

    # ✅ Add protected profile route
    @app.route('/auth/me', methods=['GET'])
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

    # Register blueprints
    app.register_blueprint(practice_bp, url_prefix='/practice')
    app.register_blueprint(auth_bp, url_prefix='/auth')

    # Create DB tables
    with app.app_context():
        db.create_all()

    return app

# ---------------- WSGI ENTRY POINT ----------------
app = create_app()

# if __name__ == "__main__":
#     port = int(os.environ.get("PORT", 5001))
#     app.run(host="0.0.0.0", port=port)
