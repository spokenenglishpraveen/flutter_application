import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Your api_service.dart path

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _teluguVerb = '';
  String _userAnswer = '';
  String _feedbackMessage = '';
  bool _showAnswer = false;
  List<String> _history = [];
  int _currentIndex = -1; // Track position in history

  @override
  void initState() {
    super.initState();
    _fetchNewVerb();
  }

  Future<void> _fetchNewVerb() async {
    final verb = await ApiService.getVerb();
    setState(() {
      _teluguVerb = verb['telugu'] ?? '';
      _userAnswer = '';
      _feedbackMessage = '';
      _showAnswer = false;

      // Add to history only if not repeating current verb
      if (_currentIndex == -1 || (_history.isEmpty || _history[_currentIndex] != _teluguVerb)) {
        _history.add(_teluguVerb);
        _currentIndex = _history.length - 1;
      }
    });
  }

  void _goPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _teluguVerb = _history[_currentIndex];
        _userAnswer = '';
        _feedbackMessage = '';
        _showAnswer = false;
      });
    }
  }

  void _goNext() {
    if (_currentIndex < _history.length - 1) {
      setState(() {
        _currentIndex++;
        _teluguVerb = _history[_currentIndex];
        _userAnswer = '';
        _feedbackMessage = '';
        _showAnswer = false;
      });
    } else {
      // Fetch a new verb if at end
      _fetchNewVerb();
    }
  }

  Future<void> _checkAnswer() async {
    if (_userAnswer.trim().isEmpty) {
      setState(() {
        _feedbackMessage = "Please enter your answer";
      });
      return;
    }

    final isCorrect = await ApiService.checkAnswer(_teluguVerb, _userAnswer);
    setState(() {
      _feedbackMessage = isCorrect ? "Correct!" : "Wrong!";
      _showAnswer = false; // Hide answer when checking
    });
  }

  void _revealAnswer() {
    setState(() {
      _showAnswer = true;
      _feedbackMessage = ''; // Clear feedback when revealing answer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spoken English Practice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Translate this Telugu verb to English:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 12),
            Text(
              _teluguVerb,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            TextField(
              onChanged: (value) => _userAnswer = value,
              decoration: InputDecoration(
                labelText: 'Your English Translation',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: _goPrevious,
                  child: Text('Previous Verb'),
                ),
                ElevatedButton(
                  onPressed: _goNext,
                  child: Text('Next Verb'),
                ),
                ElevatedButton(
                  onPressed: _checkAnswer,
                  child: Text('Check Answer'),
                ),
                ElevatedButton(
                  onPressed: _revealAnswer,
                  child: Text('Reveal Answer'),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_feedbackMessage.isNotEmpty)
              Text(
                _feedbackMessage,
                style: TextStyle(
                  color: _feedbackMessage == "Correct!" ? Colors.green : Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (_showAnswer)
              FutureBuilder<Map<String, String>>(
                future: ApiService.getVerbAnswer(_teluguVerb),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading answer');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return SizedBox.shrink();
                  } else {
                    return Text(
                      'Answer: ${snapshot.data!['english']}',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
