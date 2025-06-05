import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({Key? key}) : super(key: key);

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  String englishVerb = '';
  TextEditingController _controller = TextEditingController();
  String resultMessage = '';
  bool isLoading = false;

  final String baseUrl = 'http://127.0.0.1:5000'; // Change to your Flask backend URL

  @override
  void initState() {
    super.initState();
    fetchNewVerb();
  }

  Future<void> fetchNewVerb() async {
    setState(() {
      isLoading = true;
      resultMessage = '';
      _controller.clear();
    });

    final response = await http.get(Uri.parse('$baseUrl/verb'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        englishVerb = data['english'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        resultMessage = 'Failed to load verb';
        isLoading = false;
      });
    }
  }

  Future<void> checkTranslation() async {
    final userTranslation = _controller.text.trim();

    if (userTranslation.isEmpty) {
      setState(() {
        resultMessage = 'Please enter a translation';
      });
      return;
    }

    setState(() {
      isLoading = true;
      resultMessage = '';
    });

    final response = await http.post(
      Uri.parse('$baseUrl/check'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'english_verb': englishVerb,
        'user_translation': userTranslation,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        resultMessage = data['correct'] == true ? 'Correct ✅' : 'Wrong ❌';
        isLoading = false;
      });
    } else {
      setState(() {
        resultMessage = 'Error checking translation';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verb Translation Practice')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading && englishVerb.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Translate this verb to Telugu:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    englishVerb,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Your translation',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: checkTranslation,
                    child: Text('Check'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    resultMessage,
                    style: TextStyle(
                      fontSize: 20,
                      color: resultMessage.startsWith('Correct')
                          ? Colors.green
                          : Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: fetchNewVerb,
                    child: Text('Next Verb'),
                  ),
                ],
              ),
      ),
    );
  }
}
