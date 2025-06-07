// practice_tenses_screen.dart
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PracticeTensesScreen extends StatefulWidget {
  const PracticeTensesScreen({super.key});

  @override
  State<PracticeTensesScreen> createState() => _PracticeTensesScreenState();
}

class _PracticeTensesScreenState extends State<PracticeTensesScreen> {
  final List<String> tenses = ['Simple Present', 'Simple Past', 'Simple Future'];
  String selectedTense = 'Simple Present';
  Map<String, String>? currentSentence;
  final TextEditingController _controller = TextEditingController();
  String feedback = '';
  String correctAnswer = '';

  @override
  void initState() {
    super.initState();
    fetchTense();
  }

  Future<void> fetchTense() async {
    final tenseKey = selectedTense.toLowerCase().replaceAll('simple ', '');
    final data = await ApiService.getTense(tenseKey);
    setState(() {
      currentSentence = data;
      feedback = '';
      correctAnswer = '';
      _controller.clear();
    });
  }

  Future<void> checkAnswer() async {
    if (currentSentence == null) return;
    final isCorrect = await ApiService.checkTenseAnswer(
      currentSentence!.keys.first,
      _controller.text.trim(),
    );
    setState(() {
      feedback = isCorrect ? '✅ Correct!' : '❌ Try Again';
    });
  }

  Future<void> showAnswer() async {
    if (currentSentence == null) return;
    final tenseKey = selectedTense.toLowerCase().replaceAll('simple ', '');
    final data = await ApiService.getTenseAnswer(currentSentence!.keys.first, tenseKey);
    setState(() {
      correctAnswer = data.values.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice Tenses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: selectedTense,
              items: tenses.map((tense) {
                return DropdownMenuItem(
                  value: tense,
                  child: Text(tense),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedTense = value);
                  fetchTense();
                }
              },
            ),
            const SizedBox(height: 20),
            if (currentSentence != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Translate this:', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(currentSentence!.keys.first, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Your answer',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: checkAnswer, child: const Text('Check')),
                  if (feedback.isNotEmpty) Text(feedback, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: showAnswer, child: const Text('Show Answer')),
                  if (correctAnswer.isNotEmpty)
                    Text('Answer: $correctAnswer', style: const TextStyle(fontSize: 16, color: Colors.blue))
                ],
              ),
          ],
        ),
      ),
    );
  }
}
