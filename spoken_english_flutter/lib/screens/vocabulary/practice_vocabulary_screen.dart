import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PracticeVocabularyScreen extends StatefulWidget {
  const PracticeVocabularyScreen({super.key});

  @override
  State<PracticeVocabularyScreen> createState() => _PracticeVocabularyScreenState();
}

class _PracticeVocabularyScreenState extends State<PracticeVocabularyScreen> {
  Map<String, dynamic>? _currentWord;
  String _userInput = '';
  bool? _isCorrect;
  bool _showAnswer = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRandomWord();
  }

  Future<void> _loadRandomWord() async {
    setState(() {
      _isLoading = true;
      _userInput = '';
      _isCorrect = null;
      _showAnswer = false;
    });

    try {
      final word = await ApiService.getRandomVocabularyWord();
      setState(() {
        _currentWord = word;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading vocabulary word: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkAnswer() async {
    if (_currentWord == null) return;

    final correct = _currentWord!['word']?.toString().toLowerCase().trim() == _userInput.toLowerCase().trim();

    setState(() {
      _isCorrect = correct;
      _showAnswer = true; // Always show full answer after checking
    });
  }

  Widget _buildPracticeCard() {
    if (_currentWord == null) {
      return const Center(child: Text('No word loaded.'));
    }

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '📘 Telugu: ${_currentWord!['telugu_meaning'] ?? ''}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter the English word',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _userInput = value),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: const Text('Check Answer'),
            ),
            const SizedBox(height: 20),
            if (_isCorrect != null)
              Text(
                _isCorrect! ? '✅ Correct!' : '❌ Incorrect',
                style: TextStyle(
                  fontSize: 18,
                  color: _isCorrect! ? Colors.green : Colors.red,
                ),
              ),
            if (_showAnswer)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 30),
                  Text('📘 English: ${_currentWord!['word'] ?? ''}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('📙 ఉదాహరణ: ${_currentWord!['example_telugu'] ?? ''}', style: const TextStyle(fontSize: 16)),
                  Text('📗 Example: ${_currentWord!['example_english'] ?? ''}', style: const TextStyle(fontSize: 16)),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadRandomWord,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Another'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice Vocabulary')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(child: _buildPracticeCard()),
    );
  }
}
