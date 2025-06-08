import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://flutterapplication-production.up.railway.app';

  // --- VERBS ---

  // Get all verbs as a list of maps (each with v1, v2, v3, ing, telugu_meaning, examples)
  static Future<List<Map<String, dynamic>>> getAllVerbs() async {
    final response = await http.get(Uri.parse('$baseUrl/practice/verbs'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load verbs');
    }
  }

  // Get a random verb from backend
  static Future<Map<String, dynamic>> getRandomVerb() async {
    final response = await http.get(Uri.parse('$baseUrl/practice/verbs/random'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load random verb');
    }
  }

  // --- TENSES ---

  // Get list of available tenses
  static Future<List<String>> getTenseList() async {
    final response = await http.get(Uri.parse('$baseUrl/practice/tenses-list'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load tenses list');
    }
  }

  // Get Telugu-English sentence pair for practice of a given tense
  static Future<Map<String, String>> getTenseSentence(String tense) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/practice/tenses/practice?tense=${Uri.encodeComponent(tense)}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        "telugu": data["telugu"],
        "english": data["english"],
      };
    } else {
      throw Exception('Failed to load tense sentence');
    }
  }

  // Check user's translation answer for a Telugu sentence in a tense
  static Future<bool> checkTenseAnswer(String teluguSentence, String englishAnswer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/practice/tenses/check'),
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

  // Get correct English translation answer for a Telugu sentence (tense practice)
  static Future<Map<String, String>> getTenseAnswer(String teluguSentence) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/practice/tenses/answer?telugu=${Uri.encodeComponent(teluguSentence)}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        "telugu": data['telugu'],
        "english": data['english'],
      };
    } else {
      throw Exception('Failed to load tense answer');
    }
  }

  // --- VOCABULARY ---

  // Fetch the full vocabulary list
  static Future<List<Map<String, String>>> getVocabularyList() async {
    final response = await http.get(Uri.parse('$baseUrl/practice/vocabulary'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Map<String, String>.from(item)).toList();
    } else {
      throw Exception('Failed to load vocabulary list');
    }
  }

  // Fetch a random Telugu word for practice
  static Future<Map<String, String>> getRandomVocabularyWord() async {
    final response = await http.get(Uri.parse('$baseUrl/practice/vocabulary/random'));
    if (response.statusCode == 200) {
      return Map<String, String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch random vocabulary word');
    }
  }

  // Fetch full details of a Telugu word
  static Future<Map<String, String>> getVocabularyAnswer(String teluguWord) async {
    final response = await http.get(Uri.parse(
      '$baseUrl/practice/vocabulary/answer?telugu=${Uri.encodeComponent(teluguWord)}',
    ));

    if (response.statusCode == 200) {
      return Map<String, String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch vocabulary answer');
    }
  }
}
