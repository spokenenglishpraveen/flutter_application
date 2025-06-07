from flask import Flask, jsonify, request, Blueprint
from flask_cors import CORS
import random

from data.verbs_data import verbs_dict as verbs
from data.vocabulary_data import vocabulary_dict
from data.tenses_data import tenses_dict




practice_bp = Blueprint('practice', __name__)
verbs_bp = Blueprint('verbs', __name__)

# ✅ TENSES ENDPOINTS
@practice_bp.route('/tenses-list', methods=['GET'], strict_slashes=False)
def get_tense_list():
    return jsonify(list(tenses.keys()))

@practice_bp.route('/tenses/<tense>', methods=['GET'], strict_slashes=False)
def get_tense_data(tense):
    data = tenses.get(tense)
    if not data:
        return jsonify({"error": "Tense not found"}), 404
    return jsonify([{"telugu": t[0], "english": t[1]} for t in data])

@practice_bp.route('/tenses/practice', methods=['GET'], strict_slashes=False)
def get_random_tense_sentence():
    tense = request.args.get('tense')
    data = tenses.get(tense)
    if not data:
        return jsonify({"error": "Tense not found"}), 404
    sentence = random.choice(data)
    return jsonify(sentence)

@practice_bp.route('/tenses/check', methods=['POST'], strict_slashes=False)
def check_tense_sentence():
    data = request.json
    telugu = data.get('telugu_sentence')
    user_input = data.get('user_translation', '').strip().lower()

    for sentence_list in tenses.values():
        match = next((s for s in sentence_list if s[0] == telugu), None)
        if match:
            return jsonify({"correct": user_input == match[1].strip().lower()})
    return jsonify({"error": "Sentence not found"}), 404

@practice_bp.route('/tenses/answer', methods=['GET'], strict_slashes=False)
def get_tense_answer():
    telugu = request.args.get('telugu')
    for sentence_list in tenses.values():
        match = next((s for s in sentence_list if s[0] == telugu), None)
        if match:
            return jsonify({"telugu": match[0], "english": match[1]})
    return jsonify({"error": "Sentence not found"}), 404


# ✅ VERBS ENDPOINTS
@verbs_bp.route('', methods=['GET'], strict_slashes=False)
def get_all_verbs():
    return jsonify(list(verbs.values()))

@verbs_bp.route('/search', methods=['GET'], strict_slashes=False)
def search_verbs():
    query = request.args.get('q', '').lower()
    filtered = [v for k, v in verbs.items() if query in k.lower()]
    return jsonify(filtered)

@verbs_bp.route('/random', methods=['GET'], strict_slashes=False)
def get_random_verb():
    verb = random.choice(list(verbs.values()))
    return jsonify(verb)

@verbs_bp.route('/check', methods=['POST'], strict_slashes=False)
def check_verb_translation():
    data = request.json
    telugu = data.get('telugu')
    user_input = data.get('user_input', '').strip().lower()
    match = next((v for v in verbs.values() if v['telugu_meaning'] == telugu), None)
    if not match:
        return jsonify({"error": "Verb not found"}), 404
    return jsonify({"correct": user_input == match['v1'].strip().lower()})

@verbs_bp.route('/answer', methods=['GET'], strict_slashes=False)
def get_verb_answer():
    telugu = request.args.get('telugu')
    match = next((v for v in verbs.values() if v['telugu_meaning'] == telugu), None)
    if match:
        return jsonify(match)
    return jsonify({"error": "Verb not found"}), 404


# ✅ APP SETUP
def create_app():
    app = Flask(__name__)
    app.url_map.strict_slashes = False  # This disables strict slash behavior globally
    CORS(app)
    app.register_blueprint(practice_bp, url_prefix='/practice')
    app.register_blueprint(verbs_bp, url_prefix='/verbs')
    return app

app = create_app()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000, debug=True)
