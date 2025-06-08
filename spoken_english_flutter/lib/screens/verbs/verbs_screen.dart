import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'learn_verbs_screen.dart';

class VerbsScreen extends StatefulWidget {
  const VerbsScreen({super.key});

  @override
  State<VerbsScreen> createState() => _VerbsScreenState();
}

class _VerbsScreenState extends State<VerbsScreen> {
  List<Map<String, dynamic>> _verbs = [];
  List<Map<String, dynamic>> _filteredVerbs = [];
  bool _isLoading = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchVerbs();
  }

  void fetchVerbs() async {
    try {
      final data = await ApiService.getAllVerbs();
      setState(() {
        _verbs = data;
        _filteredVerbs = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _verbs = [];
        _filteredVerbs = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load verbs. Please try again.")),
      );
    }
  }

  void _filterVerbs(String query) {
    setState(() {
      _searchQuery = query;
      _filteredVerbs = _verbs.where((verb) {
        final v1 = (verb['v1'] ?? '').toString().toLowerCase();
        final telugu = (verb['telugu_meaning'] ?? '').toString().toLowerCase();
        final q = query.toLowerCase();
        return v1.contains(q) || telugu.contains(q);
      }).toList();
    });
  }

  void _navigateToDetails(Map<String, dynamic> verb) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LearnVerbsScreen(verb: verb)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verbs")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Search Verb or Meaning",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterVerbs,
                  ),
                ),
                if (_filteredVerbs.isEmpty && _searchQuery.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "No verbs found matching your search.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                if (_filteredVerbs.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredVerbs.length,
                      itemBuilder: (context, index) {
                        final verb = _filteredVerbs[index];
                        return ListTile(
                          title: Text(verb['v1'] ?? ''),
                          subtitle: Text(verb['telugu_meaning'] ?? ''),
                          // You can replace trailing with something meaningful or remove it
                          // trailing: Text(verb['vector_icon'] ?? ''), 
                          onTap: () => _navigateToDetails(verb),
                        );
                      },
                    ),
                  ),
              ],
            ),
    );
  }
}
