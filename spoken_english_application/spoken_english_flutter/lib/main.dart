import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/practice_verbs_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spoken English App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
      routes: {
        '/practice_verbs': (context) => const PracticeVerbsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
