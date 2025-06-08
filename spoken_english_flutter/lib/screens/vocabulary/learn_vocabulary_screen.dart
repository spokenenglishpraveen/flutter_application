import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class LearnVocabularyScreen extends StatefulWidget {
  const LearnVocabularyScreen({super.key});

  @override
  State<LearnVocabularyScreen> createState() => _LearnVocabularyScreenState();
}

class _LearnVocabularyScreenState extends State<LearnVocabularyScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _vocabulary = [];
  List<Map<String, dynamic>> _filteredVocabulary = [];
  Map<String, dynamic>? _selectedWord;
  bool _isLoading = true;

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
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading vocabulary: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearch(String value) {
    value = value.toLowerCase();
    final matches = _vocabulary.where((word) =>
      (word['word'] ?? '').toString().toLowerCase().contains(value)).toList();

    if (matches.length == 1 &&
        (matches.first['word'] ?? '').toString().toLowerCase() == value) {
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
      _searchController.text = (word['word'] ?? '').toString();
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
            Text("🔤 English: ${word['word'] ?? ''}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("🔠 Telugu: ${word['telugu_meaning'] ?? ''}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("📘 Example: ${word['example_english'] ?? ''}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("📙 ఉదాహరణ: ${word['example_telugu'] ?? ''}", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildVocabularyList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _filteredVocabulary.length,
        itemBuilder: (context, index) {
          final word = _filteredVocabulary[index];
          return ListTile(
            title: Text(word['word'] ?? ''),
            subtitle: Text(word['telugu_meaning'] ?? ''),
            onTap: () => _onSelectWord(word),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn Vocabulary')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    decoration: const InputDecoration(
                      hintText: 'Search for a word...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedWord != null)
                    _buildWordDetails(_selectedWord!)
                  else
                    _buildVocabularyList(),
                ],
              ),
            ),
    );
  }
}
