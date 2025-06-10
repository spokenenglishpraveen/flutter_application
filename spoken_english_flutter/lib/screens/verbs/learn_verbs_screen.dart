import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class LearnVerbsScreen extends StatefulWidget {
  final int level;

  const LearnVerbsScreen({super.key, required this.level});

  @override
  State<LearnVerbsScreen> createState() => _LearnVerbsScreenState();
}

class _LearnVerbsScreenState extends State<LearnVerbsScreen> {
  List<Map<String, dynamic>> _verbs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVerbs();
  }

  Future<void> _fetchVerbs() async {
    try {
      final verbs = await ApiService.getVerbsByLevel(widget.level);
      setState(() {
        _verbs = verbs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading verbs: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load verbs. Please try again.")),
      );
    }
  }

  Widget _buildVerbCard(Map<String, dynamic> verb) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🔤 V1: ${verb['v1']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("🕒 V2: ${verb['v2']}", style: const TextStyle(fontSize: 18)),
            Text("✅ V3: ${verb['v3']}", style: const TextStyle(fontSize: 18)),
            Text("🔄 ING Form: ${verb['ing']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("📘 Telugu Meaning: ${verb['telugu_meaning']}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("📖 Example (English): ${verb['example_english']}", style: const TextStyle(fontSize: 15)),
            Text("📙 ఉదాహరణ (Telugu): ${verb['example_telugu']}", style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Learn Verbs - Level ${widget.level}")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _verbs.isEmpty
              ? const Center(child: Text("No verbs available for this level."))
              : ListView.builder(
                  itemCount: _verbs.length,
                  itemBuilder: (context, index) => _buildVerbCard(_verbs[index]),
                ),
    );
  }
}
