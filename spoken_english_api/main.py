from flask import Flask, jsonify, request, Blueprint
from flask_cors import CORS
import random
import os

# Import data dictionaries
from data.verbs_data import verbs_dict
from data.vocabulary_data import vocab_dict
from data.tenses_data import tenses


# ✅ Convert vocab_dict to a list
vocabulary = list(vocab_dict.values())

# Blueprint setup
practice_bp = Blueprint('practice', __name__)

# --- TENSES ROUTES ---
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

# --- VERBS ROUTE ---
@practice_bp.route('/verbs', methods=['GET'])
def get_verbs():
    return jsonify(list(verbs_dict.values()))

# --- VOCABULARY ROUTES ---
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

# --- HEALTH CHECK ---
@practice_bp.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "ok"})

# --- APP SETUP ---
def create_app():
    app = Flask(__name__)
    CORS(app)
    app.register_blueprint(practice_bp, url_prefix='/practice')
    return app

# --- WSGI ENTRY POINT ---
app = create_app()

# Uncomment for local development
# if __name__ == "__main__":
#     port = int(os.environ.get("PORT", 5000))
#     app.run(host="0.0.0.0", port=port)
