import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PracticeTensesScreen extends StatefulWidget {
  const PracticeTensesScreen({super.key});

  @override
  State<PracticeTensesScreen> createState() => _PracticeTensesScreenState();
}

class _PracticeTensesScreenState extends State<PracticeTensesScreen> {
  List<String> availableTenses = [];
  String selectedTense = '';
  List<Map<String, String>> sentenceList = [];
  int currentIndex = 0;
  String userAnswer = '';
  String feedback = '';
  bool showCorrectAnswer = false;

  @override
  void initState() {
    super.initState();
    loadTenses();
  }

  Future<void> loadTenses() async {
    try {
      final tenses = await ApiService.getTenseList();
      setState(() {
        availableTenses = tenses;
        selectedTense = tenses.first;
      });
      loadSentence();
    } catch (e) {
      print('Failed to load tenses: $e');
    }
  }

  Future<void> loadSentence() async {
    try {
      final sentence = await ApiService.getTenseSentence(selectedTense);
      setState(() {
        sentenceList = [sentence];
        currentIndex = 0;
        feedback = '';
        userAnswer = '';
        showCorrectAnswer = false;
      });
    } catch (e) {
      print('Failed to load sentence: $e');
    }
  }

  void nextSentence() {
    loadSentence(); // Simulate getting a new one
  }

  void previousSentence() {
    // You could implement history later
  }

  Future<void> checkAnswer() async {
    try {
      final telugu = sentenceList[currentIndex]['telugu'] ?? '';
      final isCorrect = await ApiService.checkTenseAnswer(telugu, userAnswer);
      setState(() {
        feedback = isCorrect ? 'Correct!' : 'Incorrect';
        showCorrectAnswer = !isCorrect;
      });
    } catch (e) {
      print('Error checking answer: $e');
    }
  }

  Future<void> showAnswer() async {
    try {
      final telugu = sentenceList[currentIndex]['telugu'] ?? '';
      final result = await ApiService.getTenseAnswer(telugu);
      setState(() {
        feedback = 'Answer: ${result['english']}';
      });
    } catch (e) {
      print('Error fetching answer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sentence = sentenceList.isNotEmpty ? sentenceList[currentIndex] : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Practice Tenses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: availableTenses.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: selectedTense,
                    items: availableTenses
                        .map((tense) => DropdownMenuItem(
                              value: tense,
                              child: Text(tense[0].toUpperCase() + tense.substring(1)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedTense = value;
                        });
                        loadSentence();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  if (sentence != null) ...[
                    Text(
                      'Translate this Telugu sentence:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(sentence['telugu'] ?? '', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 20),
                    TextField(
                      onChanged: (value) => userAnswer = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Your English translation',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(feedback, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: previousSentence,
                          child: const Text('Previous'),
                        ),
                        ElevatedButton(
                          onPressed: checkAnswer,
                          child: const Text('Check'),
                        ),
                        ElevatedButton(
                          onPressed: showAnswer,
                          child: const Text('Show Answer'),
                        ),
                        ElevatedButton(
                          onPressed: nextSentence,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
      ),
    );
  }
}
