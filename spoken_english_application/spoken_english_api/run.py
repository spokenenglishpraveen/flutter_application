from flask import Flask, jsonify, request, Blueprint
from flask_cors import CORS
import random



practice_bp = Blueprint('practice', __name__)

verbs = [
  {
    "english": "analyze",
    "telugu": "విశ్లేషించు"
  },
  {
    "english": "appreciate",
    "telugu": "అభినందించు"
  },
  {
    "english": "negotiate",
    "telugu": "చర్చించు"
  },
  {
    "english": "implement",
    "telugu": "అమలు చేయు"
  },
  {
    "english": "recommend",
    "telugu": "సూచించు"
  },
  {
    "english": "postpone",
    "telugu": "వాయిదా వేయు"
  },
  {
    "english": "identify",
    "telugu": "గుర్తించు"
  },
  {
    "english": "influence",
    "telugu": "ప్రభావితం చేయు"
  },
  {
    "english": "interrupt",
    "telugu": "అవరోధించు"
  },
  {
    "english": "contribute",
    "telugu": "కొందించు"
  },
  {
    "english": "persuade",
    "telugu": "ఊహింపజేయు"
  },
  {
    "english": "coordinate",
    "telugu": "సంయోజించు"
  },
  {
    "english": "facilitate",
    "telugu": "సులభతరం చేయు"
  },
  {
    "english": "monitor",
    "telugu": "పర్యవేక్షించు"
  },
  {
    "english": "evaluate",
    "telugu": "ఆకలించు"
  },
  {
    "english": "participate",
    "telugu": "పాల్గొను"
  },
  {
    "english": "communicate",
    "telugu": "సంప్రేషించు"
  },
  {
    "english": "navigate",
    "telugu": "దారి చూపు"
  },
  {
    "english": "collaborate",
    "telugu": "ఒకటిగా పనిచేయు"
  },
  {
    "english": "anticipate",
    "telugu": "అంచనా వేయు"
  },
  {
    "english": "analyze",
    "telugu": "విశ్లేషించు"
  },
  {
    "english": "appreciate",
    "telugu": "అభినందించు"
  },
  {
    "english": "negotiate",
    "telugu": "చర్చించు"
  },
  {
    "english": "implement",
    "telugu": "అమలు చేయు"
  },
  {
    "english": "recommend",
    "telugu": "సూచించు"
  },
  {
    "english": "postpone",
    "telugu": "వాయిదా వేయు"
  },
  {
    "english": "identify",
    "telugu": "గుర్తించు"
  },
  {
    "english": "influence",
    "telugu": "ప్రభావితం చేయు"
  },
  {
    "english": "interrupt",
    "telugu": "అవరోధించు"
  },
  {
    "english": "contribute",
    "telugu": "కొందించు"
  },
  {
    "english": "persuade",
    "telugu": "ఊహింపజేయు"
  },
  {
    "english": "coordinate",
    "telugu": "సంయోజించు"
  },
  {
    "english": "facilitate",
    "telugu": "సులభతరం చేయు"
  },
  {
    "english": "monitor",
    "telugu": "పర్యవేక్షించు"
  },
  {
    "english": "evaluate",
    "telugu": "ఆకలించు"
  },
  {
    "english": "participate",
    "telugu": "పాల్గొను"
  },
  {
    "english": "communicate",
    "telugu": "సంప్రేషించు"
  },
  {
    "english": "navigate",
    "telugu": "దారి చూపు"
  },
  {
    "english": "collaborate",
    "telugu": "ఒకటిగా పనిచేయు"
  },
  {
    "english": "anticipate",
    "telugu": "అంచనా వేయు"
  },
  {
    "english": "analyze",
    "telugu": "విశ్లేషించు"
  },
  {
    "english": "appreciate",
    "telugu": "అభినందించు"
  },
  {
    "english": "negotiate",
    "telugu": "చర్చించు"
  },
  {
    "english": "implement",
    "telugu": "అమలు చేయు"
  },
  {
    "english": "recommend",
    "telugu": "సూచించు"
  },
  {
    "english": "postpone",
    "telugu": "వాయిదా వేయు"
  },
  {
    "english": "identify",
    "telugu": "గుర్తించు"
  },
  {
    "english": "influence",
    "telugu": "ప్రభావితం చేయు"
  },
  {
    "english": "interrupt",
    "telugu": "అవరోధించు"
  },
  {
    "english": "contribute",
    "telugu": "కొందించు"
  },
  {
    "english": "persuade",
    "telugu": "ఊహింపజేయు"
  },
  {
    "english": "coordinate",
    "telugu": "సంయోజించు"
  },
  {
    "english": "facilitate",
    "telugu": "సులభతరం చేయు"
  },
  {
    "english": "monitor",
    "telugu": "పర్యవేక్షించు"
  },
  {
    "english": "evaluate",
    "telugu": "ఆకలించు"
  },
  {
    "english": "participate",
    "telugu": "పాల్గొను"
  },
  {
    "english": "communicate",
    "telugu": "సంప్రేషించు"
  },
  {
    "english": "navigate",
    "telugu": "దారి చూపు"
  },
  {
    "english": "collaborate",
    "telugu": "ఒకటిగా పనిచేయు"
  },
  {
    "english": "anticipate",
    "telugu": "అంచనా వేయు"
  },
  {
    "english": "analyze",
    "telugu": "విశ్లేషించు"
  },
  {
    "english": "appreciate",
    "telugu": "అభినందించు"
  },
  {
    "english": "negotiate",
    "telugu": "చర్చించు"
  },
  {
    "english": "implement",
    "telugu": "అమలు చేయు"
  },
  {
    "english": "recommend",
    "telugu": "సూచించు"
  },
  {
    "english": "postpone",
    "telugu": "వాయిదా వేయు"
  },
  {
    "english": "identify",
    "telugu": "గుర్తించు"
  },
  {
    "english": "influence",
    "telugu": "ప్రభావితం చేయు"
  },
  {
    "english": "interrupt",
    "telugu": "అవరోధించు"
  },
  {
    "english": "contribute",
    "telugu": "కొందించు"
  },
  {
    "english": "persuade",
    "telugu": "ఊహింపజేయు"
  },
  {
    "english": "coordinate",
    "telugu": "సంయోజించు"
  },
  {
    "english": "facilitate",
    "telugu": "సులభతరం చేయు"
  },
  {
    "english": "monitor",
    "telugu": "పర్యవేక్షించు"
  },
  {
    "english": "evaluate",
    "telugu": "ఆకలించు"
  },
  {
    "english": "participate",
    "telugu": "పాల్గొను"
  },
  {
    "english": "communicate",
    "telugu": "సంప్రేషించు"
  },
  {
    "english": "navigate",
    "telugu": "దారి చూపు"
  },
  {
    "english": "collaborate",
    "telugu": "ఒకటిగా పనిచేయు"
  },
  {
    "english": "anticipate",
    "telugu": "అంచనా వేయు"
  },
  {
    "english": "analyze",
    "telugu": "విశ్లేషించు"
  },
  {
    "english": "appreciate",
    "telugu": "అభినందించు"
  },
  {
    "english": "negotiate",
    "telugu": "చర్చించు"
  },
  {
    "english": "implement",
    "telugu": "అమలు చేయు"
  },
  {
    "english": "recommend",
    "telugu": "సూచించు"
  },
  {
    "english": "postpone",
    "telugu": "వాయిదా వేయు"
  },
  {
    "english": "identify",
    "telugu": "గుర్తించు"
  },
  {
    "english": "influence",
    "telugu": "ప్రభావితం చేయు"
  },
  {
    "english": "interrupt",
    "telugu": "అవరోధించు"
  },
  {
    "english": "contribute",
    "telugu": "కొందించు"
  },
  {
    "english": "persuade",
    "telugu": "ఊహింపజేయు"
  },
  {
    "english": "coordinate",
    "telugu": "సంయోజించు"
  },
  {
    "english": "facilitate",
    "telugu": "సులభతరం చేయు"
  },
  {
    "english": "monitor",
    "telugu": "పర్యవేక్షించు"
  },
  {
    "english": "evaluate",
    "telugu": "ఆకలించు"
  },
  {
    "english": "participate",
    "telugu": "పాల్గొను"
  },
  {
    "english": "communicate",
    "telugu": "సంప్రేషించు"
  },
  {
    "english": "navigate",
    "telugu": "దారి చూపు"
  },
  {
    "english": "collaborate",
    "telugu": "ఒకటిగా పనిచేయు"
  },
  {
    "english": "anticipate",
    "telugu": "అంచనా వేయు"
  },
  {
    "english": "analyze",
    "telugu": "విశ్లేషించు"
  },
  {
    "english": "appreciate",
    "telugu": "అభినందించు"
  },
  {
    "english": "negotiate",
    "telugu": "చర్చించు"
  },
  {
    "english": "implement",
    "telugu": "అమలు చేయు"
  },
  {
    "english": "recommend",
    "telugu": "సూచించు"
  },
  {
    "english": "postpone",
    "telugu": "వాయిదా వేయు"
  },
  {
    "english": "identify",
    "telugu": "గుర్తించు"
  },
  {
    "english": "influence",
    "telugu": "ప్రభావితం చేయు"
  },
  {
    "english": "interrupt",
    "telugu": "అవరోధించు"
  },
  {
    "english": "contribute",
    "telugu": "కొందించు"
  },
  {
    "english": "persuade",
    "telugu": "ఊహింపజేయు"
  },
  {
    "english": "coordinate",
    "telugu": "సంయోజించు"
  },
  {
    "english": "facilitate",
    "telugu": "సులభతరం చేయు"
  },
  {
    "english": "monitor",
    "telugu": "పర్యవేక్షించు"
  },
  {
    "english": "evaluate",
    "telugu": "ఆకలించు"
  },
  {
    "english": "participate",
    "telugu": "పాల్గొను"
  },
  {
    "english": "communicate",
    "telugu": "సంప్రేషించు"
  },
  {
    "english": "navigate",
    "telugu": "దారి చూపు"
  },
  {
    "english": "collaborate",
    "telugu": "ఒకటిగా పనిచేయు"
  },
  {
    "english": "anticipate",
    "telugu": "అంచనా వేయు"
  },
  {
    "english": "analyze",
    "telugu": "విశ్లేషించు"
  },
  {
    "english": "appreciate",
    "telugu": "అభినందించు"
  },
  {
    "english": "negotiate",
    "telugu": "చర్చించు"
  },
  {
    "english": "implement",
    "telugu": "అమలు చేయు"
  },
  {
    "english": "recommend",
    "telugu": "సూచించు"
  },
  {
    "english": "postpone",
    "telugu": "వాయిదా వేయు"
  },
  {
    "english": "identify",
    "telugu": "గుర్తించు"
  },
  {
    "english": "influence",
    "telugu": "ప్రభావితం చేయు"
  },
  {
    "english": "interrupt",
    "telugu": "అవరోధించు"
  },
  {
    "english": "contribute",
    "telugu": "కొందించు"
  },
  {
    "english": "persuade",
    "telugu": "ఊహింపజేయు"
  },
  {
    "english": "coordinate",
    "telugu": "సంయోజించు"
  },
  {
    "english": "facilitate",
    "telugu": "సులభతరం చేయు"
  },
  {
    "english": "monitor",
    "telugu": "పర్యవేక్షించు"
  },
  {
    "english": "evaluate",
    "telugu": "ఆకలించు"
  },
  {
    "english": "participate",
    "telugu": "పాల్గొను"
  },
  {
    "english": "communicate",
    "telugu": "సంప్రేషించు"
  },
  {
    "english": "navigate",
    "telugu": "దారి చూపు"
  },
  {
    "english": "collaborate",
    "telugu": "ఒకటిగా పనిచేయు"
  },
  {
    "english": "anticipate",
    "telugu": "అంచనా వేయు"
  },
  {
    "english": "analyze",
    "telugu": "విశ్లేషించు"
  },
  {
    "english": "appreciate",
    "telugu": "అభినందించు"
  },
  {
    "english": "negotiate",
    "telugu": "చర్చించు"
  },
  {
    "english": "implement",
    "telugu": "అమలు చేయు"
  },
  {
    "english": "recommend",
    "telugu": "సూచించు"
  },
  {
    "english": "postpone",
    "telugu": "వాయిదా వేయు"
  },
  {
    "english": "identify",
    "telugu": "గుర్తించు"
  },
  {
    "english": "influence",
    "telugu": "ప్రభావితం చేయు"
  },
  {
    "english": "interrupt",
    "telugu": "అవరోధించు"
  },
  {
    "english": "contribute",
    "telugu": "కొందించు"
  },
  {
    "english": "persuade",
    "telugu": "ఊహింపజేయు"
  },
  {
    "english": "coordinate",
    "telugu": "సంయోజించు"
  },
  {
    "english": "facilitate",
    "telugu": "సులభతరం చేయు"
  },
  {
    "english": "monitor",
    "telugu": "పర్యవేక్షించు"
  },
  {
    "english": "evaluate",
    "telugu": "ఆకలించు"
  },
  {
    "english": "participate",
    "telugu": "పాల్గొను"
  },
  {
    "english": "communicate",
    "telugu": "సంప్రేషించు"
  },
  {
    "english": "navigate",
    "telugu": "దారి చూపు"
  },
  {
    "english": "collaborate",
    "telugu": "ఒకటిగా పనిచేయు"
  },
  {
    "english": "anticipate",
    "telugu": "అంచనా వేయు"
  },
  {
    "english": "analyze",
    "telugu": "విశ్లేషించు"
  },
  {
    "english": "appreciate",
    "telugu": "అభినందించు"
  },
  {
    "english": "negotiate",
    "telugu": "చర్చించు"
  },
  {
    "english": "implement",
    "telugu": "అమలు చేయు"
  },
  {
    "english": "recommend",
    "telugu": "సూచించు"
  },
  {
    "english": "postpone",
    "telugu": "వాయిదా వేయు"
  },
  {
    "english": "identify",
    "telugu": "గుర్తించు"
  },
  {
    "english": "influence",
    "telugu": "ప్రభావితం చేయు"
  },
  {
    "english": "interrupt",
    "telugu": "అవరోధించు"
  },
  {
    "english": "contribute",
    "telugu": "కొందించు"
  },
  {
    "english": "persuade",
    "telugu": "ఊహింపజేయు"
  },
  {
    "english": "coordinate",
    "telugu": "సంయోజించు"
  },
  {
    "english": "facilitate",
    "telugu": "సులభతరం చేయు"
  },
  {
    "english": "monitor",
    "telugu": "పర్యవేక్షించు"
  },
  {
    "english": "evaluate",
    "telugu": "ఆకలించు"
  },
  {
    "english": "participate",
    "telugu": "పాల్గొను"
  },
  {
    "english": "communicate",
    "telugu": "సంప్రేషించు"
  },
  {
    "english": "navigate",
    "telugu": "దారి చూపు"
  },
  {
    "english": "collaborate",
    "telugu": "ఒకటిగా పనిచేయు"
  },
  {
    "english": "anticipate",
    "telugu": "అంచనా వేయు"
  },
  {
    "english": "analyze",
    "telugu": "విశ్లేషించు"
  },
  {
    "english": "appreciate",
    "telugu": "అభినందించు"
  },
  {
    "english": "negotiate",
    "telugu": "చర్చించు"
  },
  {
    "english": "implement",
    "telugu": "అమలు చేయు"
  },
  {
    "english": "recommend",
    "telugu": "సూచించు"
  },
  {
    "english": "postpone",
    "telugu": "వాయిదా వేయు"
  },
  {
    "english": "identify",
    "telugu": "గుర్తించు"
  },
  {
    "english": "influence",
    "telugu": "ప్రభావితం చేయు"
  },
  {
    "english": "interrupt",
    "telugu": "అవరోధించు"
  },
  {
    "english": "contribute",
    "telugu": "కొందించు"
  },
  {
    "english": "persuade",
    "telugu": "ఊహింపజేయు"
  },
  {
    "english": "coordinate",
    "telugu": "సంయోజించు"
  },
  {
    "english": "facilitate",
    "telugu": "సులభతరం చేయు"
  },
  {
    "english": "monitor",
    "telugu": "పర్యవేక్షించు"
  },
  {
    "english": "evaluate",
    "telugu": "ఆకలించు"
  },
  {
    "english": "participate",
    "telugu": "పాల్గొను"
  },
  {
    "english": "communicate",
    "telugu": "సంప్రేషించు"
  },
  {
    "english": "navigate",
    "telugu": "దారి చూపు"
  },
  {
    "english": "collaborate",
    "telugu": "ఒకటిగా పనిచేయు"
  },
  {
    "english": "anticipate",
    "telugu": "అంచనా వేయు"
  }
]

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

def create_app():
    app = Flask(__name__)
    CORS(app)
    app.register_blueprint(practice_bp)
    return app

app = create_app()

# if __name__ == "__main__":
#     app.run(debug=True)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)

