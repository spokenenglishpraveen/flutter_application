import 'package:flutter/material.dart';
import 'learn_vocabulary_screen.dart';
import 'practice_vocabulary_screen.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  int _selectedLevel = 1;

  void _navigateToLearn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearnVocabularyScreen(level: _selectedLevel),
      ),
    );
  }

  void _navigateToPractice(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PracticeVocabularyScreen(level: _selectedLevel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vocabulary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Select Level",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DropdownButton<int>(
              value: _selectedLevel,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLevel = value;
                  });
                }
              },
              items: List.generate(10, (index) {
                int level = index + 1;
                return DropdownMenuItem(
                  value: level,
                  child: Text("Level $level"),
                );
              }),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.menu_book),
              label: const Text("Learn Vocabulary"),
              onPressed: () => _navigateToLearn(context),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.quiz),
              label: const Text("Practice Vocabulary"),
              onPressed: () => _navigateToPractice(context),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
