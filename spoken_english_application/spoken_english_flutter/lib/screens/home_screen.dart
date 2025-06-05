import 'package:flutter/material.dart';
import '../services/api_service.dart';

// Enum for categories
enum CategoryType { verbs, vocabulary, tenses }

// Entry point HomeScreen with 3 main options
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _navigateToCategory(BuildContext context, CategoryType category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryMenuScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text('🗣️ Spoken English App'),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _navigateToCategory(context, CategoryType.verbs),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: const Color(0xFF1976D2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Verbs', style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToCategory(context, CategoryType.vocabulary),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: const Color(0xFF388E3C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Vocabulary', style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToCategory(context, CategoryType.tenses),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: const Color(0xFFF57C00),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Tenses', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
      ),
      // TODO: Add bottom navigation bar here if you want same as before
    );
  }
}

// Screen showing Learn / Practice options for a category
class CategoryMenuScreen extends StatelessWidget {
  final CategoryType category;
  const CategoryMenuScreen({Key? key, required this.category}) : super(key: key);

  String get categoryName {
    switch (category) {
      case CategoryType.verbs:
        return 'Verbs';
      case CategoryType.vocabulary:
        return 'Vocabulary';
      case CategoryType.tenses:
        return 'Tenses';
    }
  }

  void _navigateToPractice(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PracticeScreen(category: category),
      ),
    );
  }

  void _navigateToLearn(BuildContext context) {
    // For now, show simple placeholder screen for Learn
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearnScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: category == CategoryType.verbs
            ? const Color(0xFF1976D2)
            : category == CategoryType.vocabulary
                ? const Color(0xFF388E3C)
                : const Color(0xFFF57C00),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _navigateToLearn(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Learn $categoryName', style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToPractice(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: category == CategoryType.verbs
                      ? const Color(0xFF1976D2)
                      : category == CategoryType.vocabulary
                          ? const Color(0xFF388E3C)
                          : const Color(0xFFF57C00),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Practice $categoryName', style: const TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder LearnScreen - you can build your own detailed Learn screens later
class LearnScreen extends StatelessWidget {
  final CategoryType category;
  const LearnScreen({Key? key, required this.category}) : super(key: key);

  String get categoryName {
    switch (category) {
      case CategoryType.verbs:
        return 'Verbs';
      case CategoryType.vocabulary:
        return 'Vocabulary';
      case CategoryType.tenses:
        return 'Tenses';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn $categoryName'),
        backgroundColor: category == CategoryType.verbs
            ? const Color(0xFF1976D2)
            : category == CategoryType.vocabulary
                ? const Color(0xFF388E3C)
                : const Color(0xFFF57C00),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Learn $categoryName screen is under construction.',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// Generic Practice screen similar to your current practice verbs screen
class PracticeScreen extends StatefulWidget {
  final CategoryType category;

  const PracticeScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  String _prompt = '';
  String _userAnswer = '';
  String _feedbackMessage = '';
  bool _showAnswer = false;
  List<String> _history = [];
  int _currentIndex = -1;

  // You can extend this to handle different API endpoints based on category
  Future<void> _fetchNewPrompt() async {
    Map<String, dynamic>? data;

    try {
      switch (widget.category) {
        case CategoryType.verbs:
          data = await ApiService.getVerb();
          _prompt = data['telugu'] ?? '';
          break;
        case CategoryType.vocabulary:
          data = await ApiService.getVocabulary();
          _prompt = data['telugu'] ?? '';
          break;
        case CategoryType.tenses:
          data = await ApiService.getTense("present_simple");
;
          _prompt = data['telugu'] ?? '';
          break;
      }

      setState(() {
        _userAnswer = '';
        _feedbackMessage = '';
        _showAnswer = false;
        if (_currentIndex == -1 || (_history.isEmpty || _history[_currentIndex] != _prompt)) {
          _history.add(_prompt);
          _currentIndex = _history.length - 1;
        }
      });
    } catch (e) {
      setState(() {
        _feedbackMessage = 'Error fetching prompt';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNewPrompt();
  }

  void _goPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _prompt = _history[_currentIndex];
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
        _prompt = _history[_currentIndex];
        _userAnswer = '';
        _feedbackMessage = '';
        _showAnswer = false;
      });
    } else {
      _fetchNewPrompt();
    }
  }

  Future<void> _checkAnswer() async {
    if (_userAnswer.trim().isEmpty) {
      setState(() {
        _feedbackMessage = "Please enter your answer";
      });
      return;
    }

    bool isCorrect = false;

    try {
      switch (widget.category) {
        case CategoryType.verbs:
          isCorrect = await ApiService.checkAnswer(_prompt, _userAnswer);
          break;
        case CategoryType.vocabulary:
          isCorrect = await ApiService.checkVocabularyAnswer(_prompt, _userAnswer);
          break;
        case CategoryType.tenses:
          isCorrect = await ApiService.checkTenseAnswer(_prompt, _userAnswer);
          break;
      }
    } catch (e) {
      setState(() {
        _feedbackMessage = 'Error checking answer';
      });
      return;
    }

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

  Widget _buildAnswerWidget() {
    // Show full answer details if _showAnswer is true
    return FutureBuilder<Map<String, String>>(
      future: _fetchAnswerDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading answer'));
        } else if (!snapshot.hasData) {
          return const SizedBox.shrink();
        } else {
          final answerData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Center(
              child: Text(
                'Answer: ${answerData['english'] ?? 'N/A'}',
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
    );
  }

  Future<Map<String, String>> _fetchAnswerDetails() async {
    switch (widget.category) {
      case CategoryType.verbs:
        return await ApiService.getVerbAnswer(_prompt);
      case CategoryType.vocabulary:
        return await ApiService.getVocabularyAnswer(_prompt);
      case CategoryType.tenses:
        return await ApiService.getTenseAnswer(_prompt);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = widget.category == CategoryType.verbs
        ? const Color(0xFF1976D2)
        : widget.category == CategoryType.vocabulary
            ? const Color(0xFF388E3C)
            : const Color(0xFFF57C00);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: Text('Practice ${widget.category.name[0].toUpperCase()}${widget.category.name.substring(1)}'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.category == CategoryType.tenses
                    ? 'Translate this Telugu tense sentence:'
                    : 'Translate this Telugu word:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  _prompt,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
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
                    borderSide: BorderSide(color: primaryColor),
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
                      backgroundColor: primaryColor.withOpacity(0.7),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _goNext,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _checkAnswer,
                    icon: const Icon(Icons.check),
                    label: const Text('Check'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _revealAnswer,
                    icon: Icon(Icons.visibility, color: primaryColor),
                    label: Text('Reveal', style: TextStyle(color: primaryColor)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      color: _feedbackMessage.contains("Correct") ? Colors.green[700] : Colors.red[700],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (_showAnswer) _buildAnswerWidget(),
            ],
          ),
        ),
      ),
      // TODO: Add bottom navigation bar here if needed
    );
  }
}
