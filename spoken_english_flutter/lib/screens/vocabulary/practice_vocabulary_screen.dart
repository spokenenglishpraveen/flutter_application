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

  void loadNextWord() async {
    final word = await ApiService.getRandomVocabularyWord();
    setState(() {
      teluguWord = word['telugu'] ?? '';
      fullInfo = word;
      userAnswer = '';
      feedback = '';
    });
  }

  void checkAnswer() async {
    final isCorrect = userAnswer.trim().toLowerCase() == fullInfo['english']?.toLowerCase();
    setState(() {
      feedback = isCorrect ? '✅ Correct!' : '❌ Try again!';
    });
  }

  void revealAnswer() {
    setState(() {
      feedback = 'Answer: ${fullInfo['english']}\nSentence: ${fullInfo['example_en']}\nMeaning: ${fullInfo['meaning']}';
    });
  }

  @override
  void initState() {
    super.initState();
    loadNextWord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice Vocabulary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Translate this Telugu word to English:', style: TextStyle(fontSize: 16)),
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
            Text(feedback, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
