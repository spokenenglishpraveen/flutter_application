import 'package:flutter/material.dart';

class LearnVerbsScreen extends StatelessWidget {
  const LearnVerbsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learn Verbs")),
      body: const Center(
        child: Text("Verb theory content goes here..."),
      ),
    );
  }
}
