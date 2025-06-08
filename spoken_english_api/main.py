from flask import Flask, jsonify, request, Blueprint
from flask_cors import CORS
import random
import os  # Needed for app.run() fallback

from spoken_english_api.data.verbs_data import verbs_dict
from data.vocabulary_data import vocabulary
from data.tenses_data import tenses

# Blueprint setup
practice_bp = Blueprint('practice', __name__)

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
    return jsonify(sentence)

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

# Flask app factory
def create_app():
    app = Flask(__name__)
    CORS(app)
    app.register_blueprint(practice_bp, url_prefix='/practice')
    return app

# This is what Gunicorn will look for:
app = create_app()

# Optional: for local development
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
