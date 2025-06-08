import 'package:flutter/material.dart';
import 'package:spoken_english_flutter/screens/vocabulary/vocabulary_screen.dart';
import 'package:spoken_english_flutter/screens/tenses/tenses_screen.dart';
import 'package:spoken_english_flutter/screens/verbs/verbs_screen.dart';





class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionCard(
            context,
            title: '📘 Tenses',
            description: 'Learn and practice English tenses.',
            color: const Color(0xFFF57C00),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TensesScreen()),
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            title: '🧠 Vocabulary',
            description: 'Improve your vocabulary knowledge.',
            color: const Color(0xFF388E3C),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VocabularyScreen()),
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            title: '💪 Verbs',
            description: 'Master common English verbs.',
            color: const Color(0xFF1976D2),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VerbsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Text(title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(description, style: TextStyle(color: Colors.grey[700])),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: color),
        onTap: onTap,
      ),
    );
  }
}
