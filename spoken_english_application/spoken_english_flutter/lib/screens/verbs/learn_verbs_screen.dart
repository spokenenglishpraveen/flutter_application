import 'package:flutter/material.dart';

class LearnVerbsScreen extends StatelessWidget {
  final Map<String, dynamic> verb;

  const LearnVerbsScreen({super.key, required this.verb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verb: ${verb['v1']}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("V1: ${verb['v1']}", style: const TextStyle(fontSize: 18)),
            Text("V2: ${verb['v2']}", style: const TextStyle(fontSize: 18)),
            Text("V3: ${verb['v3']}", style: const TextStyle(fontSize: 18)),
            Text("ING: ${verb['ing']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Telugu Meaning: ${verb['telugu_meaning']}"),
            const SizedBox(height: 10),
            Text("Example (English): ${verb['example_english']}"),
            Text("Example (Telugu): ${verb['example_telugu']}"),
          ],
        ),
      ),
    );
  }
}
