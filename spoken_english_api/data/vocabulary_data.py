import json

class Vocabulary:
    def __init__(self, word, telugu_meaning, icon, example_english, example_telugu):
        self.word = word
        self.telugu_meaning = telugu_meaning
        self.vector_icon = icon
        self.example_english = example_english
        self.example_telugu = example_telugu

    def to_dict(self):
        return {
            "word": self.word,
            "telugu_meaning": self.telugu_meaning,
            "vector_icon": self.vector_icon,
            "example_english": self.example_english,
            "example_telugu": self.example_telugu,
        }

# ✅ Raw vocabulary data
raw_vocab = [
    ("jeopardy", "ఆపద", "⚠️", "His careless driving put everyone in jeopardy.", "అతని నిర్లక్ష్యమైన డ్రైవింగ్ అందరినీ ఆపదలోకి నెట్టింది."),
    ("judicious", "సూక్ష్మవివేకం గల", "🧠", "She made a judicious decision under pressure.", "ఆమె ఒత్తిడిలో ఉన్నప్పటికీ సూక్ష్మవివేకంతో నిర్ణయం తీసుకుంది."),
]

# ✅ This is the key line: defining vocab_dict that you can import
vocab_dict = { word[0]: Vocabulary(*word).to_dict() for word in raw_vocab }

# ✅ Optional: print to check structure if running standalone
if __name__ == "__main__":
    print(json.dumps(vocab_dict, ensure_ascii=False, indent=2))
