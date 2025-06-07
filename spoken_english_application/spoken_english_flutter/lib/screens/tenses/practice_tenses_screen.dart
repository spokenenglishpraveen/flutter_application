import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PracticeTensesScreen extends StatefulWidget {
  const PracticeTensesScreen({super.key});

  @override
  State<PracticeTensesScreen> createState() => _PracticeTensesScreenState();
}

class _PracticeTensesScreenState extends State<PracticeTensesScreen> {
  List<String> tenses = [];
  int currentTenseIndex = 0;
  Map<String, String>? currentSentence;
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
        currentTenseIndex = 0;
      });
      if (list.isNotEmpty) {
        loadSentence(list[0]);
      }
    } catch (e) {
      setState(() {
        feedback = 'Failed to load tenses: $e';
      });
    }
  }

  Future<void> loadSentence(String tense) async {
    try {
      final sentence = await ApiService.getTenseSentence(tense);
      setState(() {
        currentSentence = sentence;
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
    if (currentSentence == null) return;
    try {
      final isCorrect = await ApiService.checkTenseAnswer(
        currentSentence!['telugu']!,
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
    if (currentSentence == null) return;
    try {
      final answer = await ApiService.getTenseAnswer(currentSentence!['telugu']!);
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

  void goToNext() {
    if (tenses.isEmpty) return;
    final nextIndex = (currentTenseIndex + 1) % tenses.length;
    setState(() {
      currentTenseIndex = nextIndex;
    });
    loadSentence(tenses[nextIndex]);
  }

  void goToPrevious() {
    if (tenses.isEmpty) return;
    final prevIndex = (currentTenseIndex - 1 + tenses.length) % tenses.length;
    setState(() {
      currentTenseIndex = prevIndex;
    });
    loadSentence(tenses[prevIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final telugu = currentSentence?['telugu'] ?? 'Loading...';
    return Scaffold(
      appBar: AppBar(title: const Text('Practice Tenses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Tense: ${tenses.isNotEmpty ? tenses[currentTenseIndex] : "Loading..."}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text('Translate this Telugu sentence:', style: const TextStyle(fontSize: 16)),
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
              children: [
                ElevatedButton(onPressed: checkAnswer, child: const Text('Check')),
                ElevatedButton(onPressed: showCorrectAnswer, child: const Text('Show Answer')),
                ElevatedButton(onPressed: goToPrevious, child: const Text('Previous')),
                ElevatedButton(onPressed: goToNext, child: const Text('Next')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
