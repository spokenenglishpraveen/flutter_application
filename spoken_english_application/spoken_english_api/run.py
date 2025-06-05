from flask import Flask, jsonify, request, Blueprint
from flask_cors import CORS
import random

practice_bp = Blueprint('practice', __name__)

# Your verbs list
verbs = [
  {"english": "analyze", "telugu": "విశ్లేషించు"},
  {"english": "appreciate", "telugu": "అభినందించు"},
  {"english": "anticipate", "telugu": "అంచనా వేయు"}
]

# Vocabulary list example
vocabulary = [
  {"english": "apple", "telugu": "ఆపిల్"},
  {"english": "book", "telugu": "పుస్తకం"},
  {"english": "car", "telugu": "కారు"}
]

# Tenses example data (each tense key maps to list of sentence pairs)
tenses = {
    "present": [
        {"english": "I eat an apple.", "telugu": "నేను ఆపిల్ తింటాను."},
        {"english": "She goes to school.", "telugu": "ఆమె పాఠశాలకు వెళుతుంది."}
    ],
    "past": [
        {"english": "I ate an apple.", "telugu": "నేను ఆపిల్ తిన్నాను."},
        {"english": "She went to school.", "telugu": "ఆమె పాఠశాలకు వెళ్ళింది."}
    ],
    # Add other tenses as needed
}

# --- Verb routes as before ---

@practice_bp.route('/verb', methods=['GET'])
def get_random_verb():
    verb = random.choice(verbs)
    return jsonify({"telugu": verb["telugu"], "english": verb["english"]})

@practice_bp.route('/check', methods=['POST'])
def check_translation():
    data = request.json
    telugu_verb = data.get('telugu_verb')
    user_translation = data.get('user_translation')

    correct_verb = next((v for v in verbs if v['telugu'] == telugu_verb), None)
    if not correct_verb:
        return jsonify({"error": "Verb not found"}), 404

    correct = (user_translation.strip().lower() == correct_verb['english'].lower())
    return jsonify({"correct": correct})

@practice_bp.route('/verb_answer', methods=['GET'])
def get_verb_answer():
    telugu_verb = request.args.get('telugu')
    if not telugu_verb:
        return jsonify({"error": "Missing telugu query parameter"}), 400

    correct_verb = next((v for v in verbs if v['telugu'] == telugu_verb), None)
    if not correct_verb:
        return jsonify({"error": "Verb not found"}), 404

    return jsonify({
        "telugu": correct_verb["telugu"],
        "english": correct_verb["english"]
    })

# --- Vocabulary routes ---

@practice_bp.route('/vocabulary', methods=['GET'])
def get_vocabulary_list():
    return jsonify(vocabulary)

@practice_bp.route('/vocabulary/practice', methods=['GET'])
def get_vocabulary_practice():
    word = random.choice(vocabulary)
    return jsonify(word)

@practice_bp.route('/vocabulary/check', methods=['POST'])
def check_vocabulary_answer():
    data = request.json
    telugu_word = data.get('telugu_word')
    user_translation = data.get('user_translation')

    correct_word = next((w for w in vocabulary if w['telugu'] == telugu_word), None)
    if not correct_word:
        return jsonify({"error": "Word not found"}), 404

    correct = (user_translation.strip().lower() == correct_word['english'].lower())
    return jsonify({"correct": correct})

# --- Tenses routes ---

@practice_bp.route('/tenses/<tense>', methods=['GET'])
def get_tense_sentences(tense):
    tense_data = tenses.get(tense.lower())
    if not tense_data:
        return jsonify({"error": "Tense not found"}), 404
    return jsonify(tense_data)

@practice_bp.route('/tenses/practice', methods=['GET'])
def get_tense_practice():
    tense = request.args.get('tense')
    if not tense:
        return jsonify({"error": "Missing tense query parameter"}), 400

    tense_data = tenses.get(tense.lower())
    if not tense_data:
        return jsonify({"error": "Tense not found"}), 404

    sentence = random.choice(tense_data)
    return jsonify(sentence)

@practice_bp.route('/tenses/check', methods=['POST'])
def check_tense_answer():
    data = request.json
    telugu_sentence = data.get('telugu_sentence')
    user_translation = data.get('user_translation')

    # Search across all tenses for simplicity, you can optimize this
    correct_sentence = None
    for tense_list in tenses.values():
        correct_sentence = next((s for s in tense_list if s['telugu'] == telugu_sentence), None)
        if correct_sentence:
            break

    if not correct_sentence:
        return jsonify({"error": "Sentence not found"}), 404

    correct = (user_translation.strip().lower() == correct_sentence['english'].lower())
    return jsonify({"correct": correct})

# ---- App setup ----

def create_app():
    app = Flask(__name__)
    CORS(app)
    app.register_blueprint(practice_bp)
    return app

app = create_app()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)
