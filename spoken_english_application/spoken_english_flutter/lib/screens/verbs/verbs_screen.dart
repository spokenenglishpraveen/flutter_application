import 'package:flutter/material.dart';

class VerbsScreen extends StatelessWidget {
  const VerbsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verbs')),
      body: const Center(child: Text('Verbs Screen')),
    );
  }
}
