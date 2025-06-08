import 'package:flutter/material.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          '📥 Your downloads will appear here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
