import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PracticeVerbsScreen extends StatefulWidget {
  const PracticeVerbsScreen({super.key});

  @override
  State<PracticeVerbsScreen> createState() => _PracticeVerbsScreenState();
}

class _PracticeVerbsScreenState extends State<PracticeVerbsScreen> {
  Map<String, dynamic>? currentVerb;
  final TextEditingController _controller = TextEditingController();
  String resultMessage = "";
  bool showAnswer = false;

  void fetchNewVerb() async {
    final data = await ApiService.getRandomVerb();
    setState(() {
      currentVerb = data;
      _controller.clear();
      resultMessage = "";
      showAnswer = false;
    });
  }

  void checkAnswer() {
    if (currentVerb == null) return;
    String userInput = _controller.text.trim().toLowerCase();
    String correct = currentVerb!['v1'].toLowerCase();
    setState(() {
      resultMessage =
          userInput == correct ? "✅ Correct!" : "❌ Wrong! Try again.";
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNewVerb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Practice Verbs")),
      body: currentVerb == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Translate this to English:",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text(currentVerb!['telugu_meaning'],
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Enter English verb",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(resultMessage, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: checkAnswer, child: const Text("Check Answer")),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showAnswer = true;
                        });
                      },
                      child: const Text("Reveal Answer")),
                  ElevatedButton(
                      onPressed: fetchNewVerb,
                      child: const Text("Next Verb")),
                  const SizedBox(height: 20),
                  if (showAnswer)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Answer: ${currentVerb!['v1']}"),
                        Text("Forms: ${currentVerb!['v1']}, ${currentVerb!['v2']}, ${currentVerb!['v3']}, ${currentVerb!['ing']}"),
                        Text("Example (EN): ${currentVerb!['example_english']}"),
                        Text("Example (TE): ${currentVerb!['example_telugu']}"),
                      ],
                    )
                ],
              ),
            ),
    );
  }
}
