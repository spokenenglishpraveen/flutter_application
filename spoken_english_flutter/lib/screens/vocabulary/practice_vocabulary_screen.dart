// practice_vocabulary_screen.dart

import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PracticeVocabularyScreen extends StatefulWidget {
  const PracticeVocabularyScreen({Key? key}) : super(key: key);

  @override
  _PracticeVocabularyScreenState createState() => _PracticeVocabularyScreenState();
}

class _PracticeVocabularyScreenState extends State<PracticeVocabularyScreen> {
  String teluguWord = '';
  String userAnswer = '';
  String feedback = '';
  Map<String, String> fullInfo = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNextWord();
  }

  Future<void> loadNextWord() async {
    setState(() {
      isLoading = true;
      feedback = '';
      userAnswer = '';
    });

    try {
      final word = await ApiService.getRandomVocabularyWord();
      setState(() {
        teluguWord = word['telugu'] ?? '';
        fullInfo = word;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        feedback = '⚠️ Failed to load word. Try again.';
        isLoading = false;
      });
    }
  }

  void checkAnswer() {
    final correct = fullInfo['english']?.toLowerCase().trim();
    final user = userAnswer.toLowerCase().trim();

    setState(() {
      feedback = user == correct ? '✅ Correct!' : '❌ Incorrect. Try again or reveal the answer.';
    });
  }

  void revealAnswer() {
    setState(() {
      feedback = '''
Answer: ${fullInfo['english'] ?? 'N/A'}
Meaning: ${fullInfo['meaning'] ?? 'N/A'}
Example: ${fullInfo['example_en'] ?? 'N/A'}
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice Vocabulary')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Translate this Telugu word to English:', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(teluguWord, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) => userAnswer = value,
                    decoration: const InputDecoration(labelText: 'Your Answer'),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    children: [
                      ElevatedButton(onPressed: checkAnswer, child: const Text('Check Answer')),
                      ElevatedButton(onPressed: revealAnswer, child: const Text('Reveal Answer')),
                      ElevatedButton(onPressed: loadNextWord, child: const Text('Next Word')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(feedback, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
    );
  }
}
