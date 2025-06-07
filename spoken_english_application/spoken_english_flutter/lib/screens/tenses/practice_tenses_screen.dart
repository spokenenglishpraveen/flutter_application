import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PracticeTensesScreen extends StatefulWidget {
  const PracticeTensesScreen({super.key});

  @override
  State<PracticeTensesScreen> createState() => _PracticeTensesScreenState();
}

class _PracticeTensesScreenState extends State<PracticeTensesScreen> {
  List<String> tenses = [];
  String? selectedTense;
  List<Map<String, String>> sentenceList = [];
  int currentIndex = 0;
  String feedback = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTenses();
  }

  Future<void> loadTenses() async {
    try {
      final list = await ApiService.getTenseList();
      setState(() {
        tenses = list;
      });
    } catch (e) {
      setState(() {
        feedback = 'Error loading tenses: $e';
      });
    }
  }

  Future<void> loadSentences(String tense) async {
    try {
      final sentence = await ApiService.getTenseSentence(tense);
      setState(() {
        sentenceList = [sentence];
        currentIndex = 0;
        feedback = '';
        _controller.clear();
      });
    } catch (e) {
      setState(() {
        feedback = 'Error loading sentence: $e';
      });
    }
  }

  void onTenseSelected(String? tense) {
    if (tense != null) {
      setState(() {
        selectedTense = tense;
        sentenceList = [];
        feedback = '';
        currentIndex = 0;
      });
      loadSentences(tense);
    }
  }

  void nextSentence() {
    if (selectedTense == null) return;
    loadSentences(selectedTense!); // Load a new random one
  }

  void previousSentence() {
    // Optional: You could implement sentence history if needed
    setState(() {
      feedback = '⏮ Previous not supported yet.';
    });
  }

  Future<void> checkAnswer() async {
    if (sentenceList.isEmpty) return;
    try {
      final telugu = sentenceList[currentIndex]["telugu"]!;
      final english = _controller.text;
      final isCorrect = await ApiService.checkTenseAnswer(telugu, english);
      setState(() {
        feedback = isCorrect ? '✅ Correct!' : '❌ Try again';
      });
    } catch (e) {
      setState(() {
        feedback = 'Error checking answer: $e';
      });
    }
  }

  Future<void> revealAnswer() async {
    if (sentenceList.isEmpty) return;
    try {
      final telugu = sentenceList[currentIndex]["telugu"]!;
      final result = await ApiService.getTenseAnswer(telugu);
      setState(() {
        feedback = '✅ Answer: ${result["english"]}';
      });
    } catch (e) {
      setState(() {
        feedback = 'Error getting answer: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTelugu = sentenceList.isNotEmpty ? sentenceList[currentIndex]["telugu"]! : "Select a tense to begin";

    return Scaffold(
      appBar: AppBar(title: const Text('Practice Tenses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for tense selection
            DropdownButton<String>(
              isExpanded: true,
              value: selectedTense,
              hint: const Text('Select a tense'),
              items: tenses.map((tense) {
                return DropdownMenuItem(
                  value: tense,
                  child: Text(tense),
                );
              }).toList(),
              onChanged: onTenseSelected,
            ),
            const SizedBox(height: 20),

            Text('Translate the following sentence:', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(currentTelugu, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Your English Translation',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Text(feedback, style: const TextStyle(fontSize: 16, color: Colors.blue)),
            const SizedBox(height: 20),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(onPressed: checkAnswer, child: const Text('Check Answer')),
                ElevatedButton(onPressed: revealAnswer, child: const Text('Reveal Answer')),
                ElevatedButton(onPressed: previousSentence, child: const Text('Previous Sentence')),
                ElevatedButton(onPressed: nextSentence, child: const Text('Next Sentence')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
