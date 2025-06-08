from flask import Flask, jsonify, request, Blueprint
from flask_cors import CORS
import random
import os

# Adjust these imports based on your directory structure
# ✅ Correct - relative to current folder (spoken_english_api)
from spoken_english_api.data.verbs_data import verbs_dict
from spoken_english_api.data.vocabulary_data import vocabulary
from spoken_english_api.data.tenses_data import tenses


# Blueprint setup
practice_bp = Blueprint('practice', __name__)

# TENSES ROUTES
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

# VERBS ROUTE
@practice_bp.route('/verbs', methods=['GET'])
def get_verbs():
    return jsonify(list(verbs_dict.values()))

# VOCABULARY ROUTE
@practice_bp.route('/vocabulary', methods=['GET'])
def get_vocabulary():
    return jsonify(vocabulary)

# Create Flask app
def create_app():
    app = Flask(__name__)
    CORS(app)
    app.register_blueprint(practice_bp, url_prefix='/practice')
    return app

# WSGI entry point
app = create_app()

# Local development only
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
