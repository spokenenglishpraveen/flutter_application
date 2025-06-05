from flask import Blueprint, jsonify, request
import random

practice_bp = Blueprint('practice', __name__)

verbs = [
    {"english": "go", "telugu": "వెళ్ళు"},
    {"english": "eat", "telugu": "తిను"},
    {"english": "run", "telugu": "పరిగెత్తు"},
]

@practice_bp.route('/verb', methods=['GET'])
def get_random_verb():
    verb = random.choice(verbs)
    return jsonify(verb)

@practice_bp.route('/check', methods=['POST'])
def check_translation():
    data = request.json
    english_verb = data.get('english_verb')
    user_translation = data.get('user_translation')

    # Find the verb's correct Telugu meaning
    correct_verb = next((v for v in verbs if v['english'] == english_verb), None)
    if not correct_verb:
        return jsonify({"error": "Verb not found"}), 404

    correct = (user_translation.strip() == correct_verb['telugu'])
    return jsonify({"correct": correct})
