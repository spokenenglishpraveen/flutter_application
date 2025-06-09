import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://flutterapplication-production.up.railway.app';

  // ============================
  //           VERBS
  // ============================

  // Get all verbs
  static Future<List<Map<String, dynamic>>> getAllVerbs() async {
    final response = await http.get(Uri.parse('$baseUrl/practice/verbs'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load verbs');
    }
  }

  // Get a random verb
  static Future<Map<String, dynamic>> getRandomVerb() async {
    final response = await http.get(Uri.parse('$baseUrl/practice/verbs/random'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load random verb');
    }
  }

  // ============================
  //           TENSES
  // ============================

  static Future<List<String>> getTenseList() async {
    final response = await http.get(Uri.parse('$baseUrl/practice/tenses-list'));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load tenses list');
    }
  }

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

  // ============================
  //         VOCABULARY
  // ============================

  // Get full vocabulary list (all levels)
  static Future<List<Map<String, String>>> getVocabularyList() async {
    final response = await http.get(Uri.parse('$baseUrl/practice/vocabulary'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Map<String, String>.from(item)).toList();
    } else {
      throw Exception('Failed to load vocabulary list');
    }
  }

  // Get vocabulary list by level
  static Future<List<Map<String, String>>> getVocabularyListByLevel(int level) async {
    final response = await http.get(Uri.parse('$baseUrl/practice/vocabulary?level=$level'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Map<String, String>.from(item)).toList();
    } else {
      throw Exception('Failed to load vocabulary for level $level');
    }
  }

  // Get one random word (no level)
  static Future<Map<String, String>> getRandomVocabularyWord() async {
    final response = await http.get(Uri.parse('$baseUrl/practice/vocabulary/random'));
    if (response.statusCode == 200) {
      return Map<String, String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch random vocabulary word');
    }
  }

  // Get one random word by level
  static Future<Map<String, String>> getRandomVocabularyWordByLevel(int level) async {
    final response = await http.get(Uri.parse('$baseUrl/practice/vocabulary/random?level=$level'));
    if (response.statusCode == 200) {
      return Map<String, String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch random word for level $level');
    }
  }

  // Get details for a specific Telugu word
  static Future<Map<String, String>> getVocabularyAnswer(String teluguWord) async {
    final response = await http.get(Uri.parse(
      '$baseUrl/practice/vocabulary/answer?telugu=${Uri.encodeComponent(teluguWord)}'));
    if (response.statusCode == 200) {
      return Map<String, String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch vocabulary answer');
    }
  }
}
