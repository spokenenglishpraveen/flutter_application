import json

class Verb:
    def __init__(self, v1, v2, v3, ing, telugu, icon, ex_en, ex_te):
        self.v1 = v1
        self.v2 = v2
        self.v3 = v3
        self.ing = ing
        self.telugu_meaning = telugu
        self.vector_icon = icon
        self.example_english = ex_en
        self.example_telugu = ex_te

    def to_dict(self):
        return {
            "v1": self.v1,
            "v2": self.v2,
            "v3": self.v3,
            "ing": self.ing,
            "telugu_meaning": self.telugu_meaning,
            "vector_icon": self.vector_icon,
            "example_english": self.example_english,
            "example_telugu": self.example_telugu,
        }

raw_verbs = [
    ("accept", "accepted", "accepted", "accepting", "అంగీకరించు", "🤝", "I accept your invitation.", "నేను మీ ఆహ్వానాన్ని అంగీకరిస్తున్నాను."),
    ("ask", "asked", "asked", "asking", "అడుగు", "❓", "She asked a difficult question.", "ఆమె కఠినమైన ప్రశ్న అడిగింది."),
    ("arrive", "arrived", "arrived", "arriving", "చేరుకోవడం", "🛬", "They arrived late to the party.", "వాళ్లు పార్టీలో ఆలస్యంగా వచ్చారు."),
    ("agree", "agreed", "agreed", "agreeing", "ఒప్పుకోవడం", "✅", "We agreed to the plan.", "మేము ఆ ప్రణాళికను ఒప్పుకున్నాము."),
    ("apologize", "apologized", "apologized", "apologizing", "క్షమాపణ చెప్పు", "🙏", "He apologized for his mistake.", "తాను చేసిన తప్పుకు అతను క్షమాపణ కోరాడు."),
    ("attend", "attended", "attended", "attending", "హాజరుకావడం", "🎓", "I attended the meeting yesterday.", "నేను నిన్న సమావేశానికి హాజరయ్యాను."),
    ("allow", "allowed", "allowed", "allowing", "అనుమతించు", "🟢", "They allowed him to enter the room.", "వారు అతన్ని గదిలోకి ప్రవేశించడానికి అనుమతించారు."),
    ("answer", "answered", "answered", "answering", "సమాధానం ఇవ్వు", "📞", "She answered all the questions.", "ఆమె అన్ని ప్రశ్నలకు సమాధానం ఇచ్చింది."),
    ("advise", "advised", "advised", "advising", "సలహా ఇవ్వు", "💬", "He advised me to study well.", "బాగాగా చదవమని అతను నాకు సలహా ఇచ్చాడు."),
    ("arrange", "arranged", "arranged", "arranging", "ఆయోజించు", "🗂️", "They arranged the chairs neatly.", "వారు కుర్చీలను బాగా అమర్చారు.")
]

verbs_dict = { verb[0]: Verb(*verb).to_dict() for verb in raw_verbs }

if __name__ == "__main__":
    print(json.dumps(verbs_dict, ensure_ascii=False, indent=2))
