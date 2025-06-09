import 'package:flutter/material.dart';
import 'learn_vocabulary_screen.dart';
import 'practice_vocabulary_screen.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key});

  void _openLevelOptions(BuildContext context, int level) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Learn Vocabulary'),
              onTap: () {
                Navigator.pop(context); // close bottom sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LearnVocabularyScreen(level: level),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Practice Vocabulary'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PracticeVocabularyScreen(level: level),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vocabulary Levels')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          final level = index + 1;
          return Card(
            child: ListTile(
              title: Text('Level $level'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _openLevelOptions(context, level),
            ),
          );
        },
      ),
    );
  }
}
