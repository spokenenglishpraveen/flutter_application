import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class LearnVocabularyScreen extends StatefulWidget {
  @override
  _LearnVocabularyScreenState createState() => _LearnVocabularyScreenState();
}

class _LearnVocabularyScreenState extends State<LearnVocabularyScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _vocabulary = [];
  List<Map<String, String>> _filteredVocabulary = [];
  Map<String, String>? _selectedWord;

  @override
  void initState() {
    super.initState();
    _loadVocabulary();
  }

  Future<void> _loadVocabulary() async {
    try {
      final vocabList = await ApiService.getVocabularyList();
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
      word['english']!.toLowerCase().contains(value)).toList();

    if (matches.length == 1 && matches.first['english']!.toLowerCase() == value) {
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

  void _onSelectWord(Map<String, String> word) {
    setState(() {
      _selectedWord = word;
      _searchController.text = word['english']!;
    });
  }

  Widget _buildWordDetails(Map<String, String> word) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🔤 English: ${word['english']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("🔠 Telugu: ${word['telugu']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("📘 Example: ${word['example']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("📙 ఉదాహరణ: ${word['example_te']}", style: TextStyle(fontSize: 16)),
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
                    title: Text(word['english'] ?? ''),
                    subtitle: Text(word['telugu'] ?? ''),
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
