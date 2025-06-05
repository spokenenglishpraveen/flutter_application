import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://flutter-application-2.onrender.com'; // Update if needed

  // GET a random Telugu verb from backend
  static Future<Map<String, String>> getVerb() async {
    final response = await http.get(Uri.parse('$baseUrl/verb'));

    if (response.statusCode == 200) {
      // Backend returns {"telugu": "verb"}
      return Map<String, String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load verb');
    }
  }

  // POST user's answer to check correctness
  static Future<bool> checkAnswer(String teluguVerb, String englishAnswer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/check'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'telugu_verb': teluguVerb,
        'user_translation': englishAnswer,
      }),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['correct'] == true;
    } else {
      throw Exception('Failed to check answer');
    }
  }

  // Fetch English answer for given Telugu verb
  static Future<Map<String, String>> getVerbAnswer(String teluguVerb) async {
    // Since backend doesn't have a separate API, we simulate by fetching from /verb and matching
    // But we need a new backend endpoint or store all verbs on client side.
    // For now, simulate a GET to /verb_answer?telugu=XXX (you can create this API backend)

    // For demonstration, let's just do a GET to /verb_answer?telugu=XXX
    final response = await http.get(Uri.parse('$baseUrl/verb_answer?telugu=$teluguVerb'));

    if (response.statusCode == 200) {
      return Map<String, String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load answer');
    }
  }
}
