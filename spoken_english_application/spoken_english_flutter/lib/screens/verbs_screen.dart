import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class VerbsScreen extends StatefulWidget {
  const VerbsScreen({super.key});

  @override
  State<VerbsScreen> createState() => _VerbsScreenState();
}

class _VerbsScreenState extends State<VerbsScreen> {
  int _selectedIndex = 0;

  void _onBottomNavTap(int index) {
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else if (index == 1) {
      Navigator.pushNamed(context, '/downloads');
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verbs'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                // You can implement Learn Verbs later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Learn Verbs coming soon!')),
                );
              },
              child: const Text('Learn Verbs'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/practice_verbs');
              },
              child: const Text('Practice Verbs'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
