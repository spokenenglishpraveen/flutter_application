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
  List<Map<String, String>> currentSentences = [];
  int currentSentenceIndex = 0;
  final TextEditingController _controller = TextEditingController();
  String feedback = '';
  bool showAnswer = false;

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
        feedback = 'Failed to load tenses: $e';
      });
    }
  }

  Future<void> loadSentences(String tense) async {
    try {
      final sentence = await ApiService.getTenseSentence(tense);
      setState(() {
        selectedTense = tense;
        currentSentences = [sentence]; // Can extend this to multiple later
        currentSentenceIndex = 0;
        feedback = '';
        showAnswer = false;
        _controller.clear();
      });
    } catch (e) {
      setState(() {
        feedback = 'Failed to load sentence: $e';
      });
    }
  }

  Future<void> loadNewSentence(String tense) async {
    try {
      final newSentence = await ApiService.getTenseSentence(tense);
      setState(() {
        currentSentences.add(newSentence);
        currentSentenceIndex = currentSentences.length - 1;
        feedback = '';
        showAnswer = false;
        _controller.clear();
      });
    } catch (e) {
      setState(() {
        feedback = 'Failed to load sentence: $e';
      });
    }
  }

  Future<void> checkAnswer() async {
    if (currentSentences.isEmpty) return;
    try {
      final isCorrect = await ApiService.checkTenseAnswer(
        currentSentences[currentSentenceIndex]['telugu']!,
        _controller.text.trim(),
      );
      setState(() {
        feedback = isCorrect ? '✅ Correct!' : '❌ Try again';
      });
    } catch (e) {
      setState(() {
        feedback = 'Error checking answer: $e';
      });
    }
  }

  Future<void> showCorrectAnswer() async {
    if (currentSentences.isEmpty) return;
    try {
      final answer = await ApiService.getTenseAnswer(
        currentSentences[currentSentenceIndex]['telugu']!,
      );
      setState(() {
        feedback = 'Answer: ${answer['english']}';
        showAnswer = true;
      });
    } catch (e) {
      setState(() {
        feedback = 'Error fetching answer: $e';
      });
    }
  }

  void goToNextSentence() async {
    if (selectedTense == null) return;
    // Load new if at last index
    if (currentSentenceIndex == currentSentences.length - 1) {
      await loadNewSentence(selectedTense!);
    } else {
      setState(() {
        currentSentenceIndex++;
        feedback = '';
        showAnswer = false;
        _controller.clear();
      });
    }
  }

  void goToPreviousSentence() {
    if (currentSentenceIndex > 0) {
      setState(() {
        currentSentenceIndex--;
        feedback = '';
        showAnswer = false;
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final telugu = currentSentences.isNotEmpty ? currentSentences[currentSentenceIndex]['telugu']! : '';
    return Scaffold(
      appBar: AppBar(title: const Text('Practice Tenses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedTense,
              hint: const Text("Select a Tense"),
              onChanged: (value) {
                if (value != null) {
                  loadSentences(value);
                }
              },
              items: tenses.map((tense) {
                return DropdownMenuItem(
                  value: tense,
                  child: Text(tense),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (currentSentences.isNotEmpty) ...[
              const Text('Translate this Telugu sentence:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text(telugu, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                spacing: 12,
                runSpacing: 10,
                children: [
                  ElevatedButton(onPressed: checkAnswer, child: const Text('Check Answer')),
                  ElevatedButton(onPressed: showCorrectAnswer, child: const Text('Reveal Answer')),
                  ElevatedButton(
                      onPressed: goToPreviousSentence,
                      child: const Text('Previous Sentence')),
                  ElevatedButton(onPressed: goToNextSentence, child: const Text('Next Sentence')),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
