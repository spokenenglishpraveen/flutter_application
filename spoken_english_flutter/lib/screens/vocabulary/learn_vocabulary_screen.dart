import 'package:flutter/material.dart';

class LearnVocabularyScreen extends StatelessWidget {
  const LearnVocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learn Vocabulary")),
      body: const Center(
        child: Text("Vocabulary theory or list will appear here..."),
      ),
    );
  }
}
