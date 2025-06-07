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

  @override
  void initState() {
    super.initState();
    fetchVerbs();
  }

  void fetchVerbs() async {
    final data = await ApiService.getAllVerbs();
    setState(() {
      _verbs = data;
      _filteredVerbs = data;
      _isLoading = false;
    });
  }

  void _filterVerbs(String query) {
    setState(() {
      _filteredVerbs = _verbs.where((verb) {
        return verb['v1'].toLowerCase().startsWith(query.toLowerCase());
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
                      labelText: "Search Verb",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterVerbs,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredVerbs.length,
                    itemBuilder: (context, index) {
                      final verb = _filteredVerbs[index];
                      return ListTile(
                        title: Text(verb['v1']),
                        subtitle: Text(verb['telugu_meaning']),
                        trailing: Text(verb['vector_icon']),
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
