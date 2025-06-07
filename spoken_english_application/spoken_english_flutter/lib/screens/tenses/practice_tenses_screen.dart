import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PracticeTensesScreen extends StatefulWidget {
  const PracticeTensesScreen({super.key});

  @override
  State<PracticeTensesScreen> createState() => _PracticeTensesScreenState();
}

class _PracticeTensesScreenState extends State<PracticeTensesScreen> {
  String selectedTense = 'present'; // Default tense
  final List<String> tenses = ['present', 'past', 'future'];
  List<Map<String, String>> sentenceList = [];
  int currentIndex = 0;

  String userInput = '';
  String feedback = '';
  bool showCorrectAnswer = false;

  @override
  void initState() {
    super.initState();
    loadSentences();
  }

  Future<void> loadSentences() async {
    final sentence = await ApiService.getTense(selectedTense);
    setState(() {
      sentenceList = [sentence];
      currentIndex = 0;
      feedback = '';
      userInput = '';
      showCorrectAnswer = false;
    });
  }

  void nextSentence() async {
    final newSentence = await ApiService.getTense(selectedTense);
    setState(() {
      sentenceList.add(newSentence);
      currentIndex++;
      userInput = '';
      feedback = '';
      showCorrectAnswer = false;
    });
  }

  void previousSentence() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        userInput = '';
        feedback = '';
        showCorrectAnswer = false;
      });
    }
  }

  Future<void> checkAnswer() async {
    final telugu = sentenceList[currentIndex]['telugu'];
    final correct = await ApiService.checkTenseAnswer(telugu!, userInput);
    setState(() {
      feedback = correct ? '✅ Correct!' : '❌ Wrong. Try again.';
    });
  }

  Future<void> revealAnswer() async {
    final telugu = sentenceList[currentIndex]['telugu'];
    final answer = await ApiService.getTenseAnswer(telugu!);
    setState(() {
      sentenceList[currentIndex] = answer;
      showCorrectAnswer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSentence = sentenceList.isNotEmpty ? sentenceList[currentIndex] : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Practice Tenses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedTense,
              items: tenses
                  .map((tense) => DropdownMenuItem(
                        value: tense,
                        child: Text(tense.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedTense = value!;
                });
                loadSentences();
              },
            ),
            const SizedBox(height: 20),
            if (currentSentence != null)
              Text(
                'Translate this Telugu sentence:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),
            if (currentSentence != null)
              Text(
                '"${currentSentence['telugu']}"',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Your English Translation',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => userInput = value,
            ),
            const SizedBox(height: 10),
            Text(feedback, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            if (showCorrectAnswer && currentSentence != null)
              Text('Correct Answer: ${currentSentence['english']}', style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(onPressed: checkAnswer, child: const Text('Check Answer')),
                ElevatedButton(onPressed: revealAnswer, child: const Text('Show Answer')),
                ElevatedButton(onPressed: previousSentence, child: const Text('Previous')),
                ElevatedButton(onPressed: nextSentence, child: const Text('Next')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
