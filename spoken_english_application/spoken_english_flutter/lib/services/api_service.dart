import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://flutter-application-2.onrender.com';

  // Get list of available tenses
  static Future<List<String>> getTenseList() async {
    final response = await http.get(Uri.parse('$baseUrl/tenses/list'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load tenses list');
    }
  }

  static Future<Map<String, String>> getTenseSentence(String tense) async {
    final response = await http.get(Uri.parse('$baseUrl/tenses/practice?tense=$tense'));
    if (response.statusCode == 200) {
      return Map<String, String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load tense sentence');
    }
  }

  static Future<bool> checkTenseAnswer(String teluguSentence, String englishAnswer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tenses/check'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'telugu_sentence': teluguSentence,
        'user_translation': englishAnswer,
      }),
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['correct'] == true;
    } else {
      throw Exception('Failed to check tense answer');
    }
  }

  static Future<Map<String, String>> getTenseAnswer(String teluguSentence) async {
    final response = await http.get(Uri.parse('$baseUrl/tenses/answer?telugu=$teluguSentence'));
    if (response.statusCode == 200) {
      return Map<String, String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load tense answer');
    }
  }
}
