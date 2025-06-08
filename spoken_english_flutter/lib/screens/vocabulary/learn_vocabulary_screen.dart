import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class LearnVocabularyScreen extends StatefulWidget {
  @override
  _LearnVocabularyScreenState createState() => _LearnVocabularyScreenState();
}

class _LearnVocabularyScreenState extends State<LearnVocabularyScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _vocabulary = [];
  List<Map<String, dynamic>> _filteredVocabulary = [];
  Map<String, dynamic>? _selectedWord;

  @override
  void initState() {
    super.initState();
    _loadVocabulary();
  }

  Future<void> _loadVocabulary() async {
    try {
      final vocabList = await ApiService.getVocabularyList(); // should return List<Map<String, dynamic>>
      setState(() {
        _vocabulary = vocabList;
        _filteredVocabulary = vocabList;
      });
    } catch (e) {
      print('Error fetching vocabulary: $e');
    }
  }

  void _onSearch(String value) {
    value = value.toLowerCase();
    final matches = _vocabulary.where((word) =>
      word['word']!.toLowerCase().contains(value)).toList();

    if (matches.length == 1 && matches.first['word']!.toLowerCase() == value) {
      setState(() {
        _selectedWord = matches.first;
        _filteredVocabulary = [];
      });
    } else {
      setState(() {
        _selectedWord = null;
        _filteredVocabulary = matches;
      });
    }
  }

  void _onSelectWord(Map<String, dynamic> word) {
    setState(() {
      _selectedWord = word;
      _searchController.text = word['word']!;
    });
  }

  Widget _buildWordDetails(Map<String, dynamic> word) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${word['vector_icon']} English: ${word['word']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("🔠 Telugu: ${word['telugu_meaning']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("📘 Example: ${word['example_english']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("📙 ఉదాహరణ: ${word['example_telugu']}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Learn Vocabulary")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Vocabulary',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearch,
            ),
          ),
          if (_selectedWord != null)
            _buildWordDetails(_selectedWord!)
          else if (_filteredVocabulary.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _filteredVocabulary.length,
                itemBuilder: (context, index) {
                  final word = _filteredVocabulary[index];
                  return ListTile(
                    leading: Text(word['vector_icon'] ?? ''),
                    title: Text(word['word'] ?? ''),
                    subtitle: Text(word['telugu_meaning'] ?? ''),
                    onTap: () => _onSelectWord(word),
                  );
                },
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text("No matching vocabulary found."),
            ),
        ],
      ),
    );
  }
}
