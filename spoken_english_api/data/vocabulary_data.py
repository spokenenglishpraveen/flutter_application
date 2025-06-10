import json

class Vocabulary:
    def __init__(self, word, telugu_meaning, icon, example_english, example_telugu, level):
        self.word = word
        self.telugu_meaning = telugu_meaning
        self.vector_icon = icon
        self.example_english = example_english
        self.example_telugu = example_telugu
        self.level = level  # ✅ Added level

    def to_dict(self):
        return {
            "word": self.word,
            "telugu_meaning": self.telugu_meaning,
            "vector_icon": self.vector_icon,
            "example_english": self.example_english,
            "example_telugu": self.example_telugu,
            "level": self.level  # ✅ Added to output
        }

# ✅ Raw vocabulary data
raw_vocab = [
    ("abandon", "వదిలివేయు", "🚪", "He decided to abandon the project due to lack of funds.", "ఆర్థిక లోపం వల్ల అతను ప్రాజెక్టును వదిలివేయాలని నిర్ణయించాడు.", 1),
    ("abate", "తగ్గించు", "📉", "The storm finally began to abate.", "తుఫాను చివరికి తగ్గడం ప్రారంభమైంది.", 1),
    ("abdicate", "త్యజించు", "👑", "The king decided to abdicate the throne.", "రాజు సింహాసనం త్యజించాలని నిర్ణయించాడు.", 1),
    ("abhor", "ద్వేషించు", "😠", "She abhors cruelty of any kind.", "ఆమె ఏ రకమైన క్రూరతను అయినా ద్వేషిస్తుంది.", 1),
    ("abide", "ఆచరించు", "📏", "You must abide by the rules.", "నీవు నియమాలను పాటించాలి.", 1),
    ("abject", "నీచమైన", "😔", "He lived in abject poverty.", "అతడు అతి నీచమైన పేదరికంలో జీవించాడు.", 1),
    ("ablaze", "ప్రకాశించే", "🔥", "The house was ablaze with lights.", "ఇల్లు వెలుగులతో ప్రకాశిస్తూ ఉంది.", 1),
    ("abnormal", "అసాధారణమైన", "⚠️", "The patient showed abnormal behavior.", "ఆ రోగి అసాధారణ ప్రవర్తనను చూపించాడు.", 1),
    ("abolish", "రద్దుచేయు", "❌", "The law was abolished in 1965.", "ఆ చట్టం 1965లో రద్దు చేయబడింది.", 2),
    ("abound", "సమృద్ధిగా ఉండటం", "🌾", "Fish abound in this river.", "ఈ నదిలో చేపలు సమృద్ధిగా ఉన్నాయి.", 3),
    ("abrasive", "గజిబిజిగా ఉన్న", "🪓", "His abrasive style annoyed many people.", "అతని గజిబిజి శైలి చాలా మందిని చిరాకుతో నింపింది.", 2),
    ("abridge", "సంక్షిప్తం చేయు", "📘", "The novel was abridged for children.", "చిన్నారుల కోసం నవలను సంక్షిప్తం చేశారు.", 2),
    ("abrupt", "ఆకస్మిక", "⚡", "His departure was very abrupt.", "అతని విడిపోవడం చాలా ఆకస్మికం.", 3),
    ("abscond", "ఓడిపోవు", "🏃‍♂️", "The thief absconded with the money.", "దొంగ డబ్బుతో పారిపోయాడు.", 2),
    ("absolve", "విముక్తి కలిగించు", "🕊️", "The priest absolved him of his sins.", "పూజారి అతని పాపాలను క్షమించాడు.", 2),
    ("absorb", "ఆమృతి చెందు", "🧽", "Sponges absorb water quickly.", "స్పాంజ్‌లు నీటిని వేగంగా ఆమరిగించుకుంటాయి.", 1),
    ("abstain", "వివరించు", "🙅", "He decided to abstain from alcohol.", "అతడు మద్యపానాన్ని నివారించడానికి నిర్ణయించాడు.", 2),
    ("abstract", "సారాంశం", "🌀", "His ideas were too abstract.", "అతని ఆలోచనలు చాలా సారాంశంగా ఉన్నాయి.", 3),
    ("absurd", "అసంభవమైన", "🤯", "It’s absurd to believe that.", "అది నమ్మడం అసంభవం.", 2),
    ("abundance", "విపులం", "💰", "The garden has an abundance of flowers.", "ఆ తోటలో విపులంగా పూలు ఉన్నాయి.", 1)
]




# ✅ Convert to dictionary
vocab_dict = { word[0]: Vocabulary(*word).to_dict() for word in raw_vocab }

# ✅ Optional check
if __name__ == "__main__":
    print(json.dumps(vocab_dict, ensure_ascii=False, indent=2))
