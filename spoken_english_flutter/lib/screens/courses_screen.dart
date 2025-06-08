import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Courses Content Goes Here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
