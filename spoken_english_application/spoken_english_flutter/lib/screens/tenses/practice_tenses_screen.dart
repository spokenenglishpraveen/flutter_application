from flask import Flask, jsonify, request, Blueprint
from flask_cors import CORS
import random

# Import data from separate files
from data.verbs_data import verbs
from data.vocabulary_data import vocabulary
from data.tenses_data import tenses

# Blueprint setup
practice_bp = Blueprint('practice', __name__)

# --- Verb Routes ---

@practice_bp.route('/verb', methods=['GET'])
def get_random_verb():
    verb = random.choice(verbs)
    return jsonify(verb)

@practice_bp.route('/check', methods=['POST'])
def check_verb_translation():
    data = request.json
    telugu = data.get('telugu_verb')
    user_input = data.get('user_translation', '').strip().lower()

    match = next((v for v in verbs if v['telugu'] == telugu), None)
    if not match:
        return jsonify({"error": "Verb not found"}), 404

    return jsonify({"correct": user_input == match['english'].lower()})

@practice_bp.route('/verb_answer', methods=['GET'])
def get_verb_answer():
    telugu = request.args.get('telugu')
    match = next((v for v in verbs if v['telugu'] == telugu), None)
    if not match:
        return jsonify({"error": "Verb not found"}), 404
    return jsonify(match)

# --- Vocabulary Routes ---

@practice_bp.route('/vocabulary', methods=['GET'])
def get_vocabulary_list():
    return jsonify(vocabulary)

@practice_bp.route('/vocabulary/practice', methods=['GET'])
def get_random_vocabulary():
    return jsonify(random.choice(vocabulary))

@practice_bp.route('/vocabulary/check', methods=['POST'])
def check_vocabulary():
    data = request.json
    telugu = data.get('telugu_word')
    user_input = data.get('user_translation', '').strip().lower()

    match = next((w for w in vocabulary if w['telugu'] == telugu), None)
    if not match:
        return jsonify({"error": "Word not found"}), 404

    return jsonify({"correct": user_input == match['english'].lower()})

# --- Tenses Routes ---

@practice_bp.route('/tenses/list', methods=['GET'])
def get_tense_list():
    return jsonify(list(tenses.keys()))

@practice_bp.route('/tenses/<tense>', methods=['GET'])
def get_tense_data(tense):
    data = tenses.get(tense.lower())
    if not data:
        return jsonify({"error": "Tense not found"}), 404
    return jsonify(data)

@practice_bp.route('/tenses/practice', methods=['GET'])
def get_random_tense_sentence():
    tense = request.args.get('tense')
    if not tense or tense.lower() not in tenses:
        return jsonify({"error": "Tense not found"}), 404
    return jsonify(random.choice(tenses[tense.lower()]))

@practice_bp.route('/tenses/check', methods=['POST'])
def check_tense_sentence():
    data = request.json
    telugu = data.get('telugu_sentence')
    user_input = data.get('user_translation', '').strip().lower()

    for sentence_list in tenses.values():
        match = next((s for s in sentence_list if s['telugu'] == telugu), None)
        if match:
            return jsonify({"correct": user_input == match['english'].lower()})

    return jsonify({"error": "Sentence not found"}), 404

@practice_bp.route('/tenses/answer', methods=['GET'])
def get_tense_answer():
    telugu = request.args.get('telugu')
    for sentence_list in tenses.values():
        match = next((s for s in sentence_list if s['telugu'] == telugu), None)
        if match:
            return jsonify(match)
    return jsonify({"error": "Sentence not found"}), 404

# --- App Setup ---

def create_app():
    app = Flask(__name__)
    CORS(app)
    app.register_blueprint(practice_bp)
    return app

app = create_app()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)
