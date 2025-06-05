import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _teluguVerb = '';
  String _userAnswer = '';
  String _feedbackMessage = '';
  bool _showAnswer = false;
  List<String> _history = [];
  int _currentIndex = -1;

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
      _feedbackMessage = isCorrect ? "✅ Correct!" : "❌ Wrong!";
      _showAnswer = false;
    });
  }

  void _revealAnswer() {
    setState(() {
      _showAnswer = true;
      _feedbackMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF), // Light bright background
      appBar: AppBar(
        title: const Text('🗣️ Spoken English Practice'),
        backgroundColor: const Color(0xFF1976D2), // Bright blue
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Translate this Telugu verb:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  _teluguVerb,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                onChanged: (value) => _userAnswer = value,
                decoration: InputDecoration(
                  labelText: 'Your English Translation',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _goPrevious,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64B5F6),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _goNext,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF42A5F5),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _checkAnswer,
                    icon: const Icon(Icons.check),
                    label: const Text('Check'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66BB6A),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _revealAnswer,
                    icon: const Icon(Icons.visibility),
                    label: const Text('Reveal'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1976D2),
                      side: const BorderSide(color: Color(0xFF1976D2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_feedbackMessage.isNotEmpty)
                Center(
                  child: Text(
                    _feedbackMessage,
                    style: TextStyle(
                      color: _feedbackMessage.contains("Correct")
                          ? Colors.green[700]
                          : Colors.red[700],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (_showAnswer)
                FutureBuilder<Map<String, String>>(
                  future: ApiService.getVerbAnswer(_teluguVerb),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading answer'));
                    } else if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Center(
                          child: Text(
                            'Answer: ${snapshot.data!['english']}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
