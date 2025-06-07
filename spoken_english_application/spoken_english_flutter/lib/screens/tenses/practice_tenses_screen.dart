import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PracticeTensesScreen extends StatefulWidget {
  const PracticeTensesScreen({Key? key}) : super(key: key);

  @override
  State<PracticeTensesScreen> createState() => _PracticeTensesScreenState();
}

class _PracticeTensesScreenState extends State<PracticeTensesScreen> {
  List<String> tenses = [];
  String? selectedTense;

  String teluguSentence = '';
  String englishAnswer = '';
  String userInput = '';
  String feedback = '';
  String error = '';

  @override
  void initState() {
    super.initState();
    loadTenses();
  }

  Future<void> loadTenses() async {
    try {
      final data = await ApiService.getTenseList();
      setState(() {
        tenses = data;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load tenses';
      });
    }
  }

  Future<void> loadSentence() async {
    setState(() {
      error = '';
      feedback = '';
      userInput = '';
    });
    try {
      final data = await ApiService.getTenseSentence(selectedTense!);
      setState(() {
        teluguSentence = data['telugu']!;
        englishAnswer = data['english']!;
      });
    } catch (e) {
      setState(() {
        error = 'Error loading sentence: $e';
      });
    }
  }

  Future<void> checkAnswer() async {
    try {
      final correct = await ApiService.checkTenseAnswer(teluguSentence, userInput);
      setState(() {
        feedback = correct ? "✅ Correct!" : "❌ Incorrect. Try again.";
      });
    } catch (e) {
      setState(() {
        feedback = 'Failed to check answer';
      });
    }
  }

  Future<void> revealAnswer() async {
    setState(() {
      feedback = "✔️ Answer: $englishAnswer";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Tenses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select a tense to practice:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Choose Tense"),
              value: selectedTense,
              items: tenses.map((tense) {
                return DropdownMenuItem<String>(
                  value: tense,
                  child: Text(tense),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTense = value;
                  teluguSentence = '';
                  englishAnswer = '';
                  feedback = '';
                });
                loadSentence();
              },
            ),

            const SizedBox(height: 20),
            if (teluguSentence.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Translate the following sentence:",
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    teluguSentence,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Your English Translation',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => userInput = value,
                  ),
                  const SizedBox(height: 12),
                  if (feedback.isNotEmpty)
                    Text(
                      feedback,
                      style: TextStyle(
                        color: feedback.contains("Correct") ? Colors.green : Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: checkAnswer,
                        child: const Text("Check Answer"),
                      ),
                      ElevatedButton(
                        onPressed: revealAnswer,
                        child: const Text("Reveal Answer"),
                      ),
                      ElevatedButton(
                        onPressed: loadSentence,
                        child: const Text("Next Sentence"),
                      ),
                    ],
                  )
                ],
              ),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(error, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
