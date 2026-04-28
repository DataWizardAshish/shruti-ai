import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/question.dart';
import '../models/episode.dart';
import '../models/saved_question.dart';
import '../models/daily_shloka.dart';
import '../models/journey_data.dart';
import '../models/home_data.dart';
import '../models/story_insight.dart';
import '../models/phase_story.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class ApiService {
  static const _baseUrl = 'http://localhost:8000';
  static const _timeout = Duration(seconds: 10);

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Question>> getQuestions({
    String? difficulty,
    String? storyPhase,
    int limit = 10,
  }) async {
    final params = <String, String>{'limit': limit.toString()};
    if (difficulty != null) params['difficulty'] = difficulty;
    if (storyPhase != null) params['story_phase'] = storyPhase;

    final uri = Uri.parse('$_baseUrl/questions').replace(queryParameters: params);
    debugPrint('[API] GET $uri');

    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      debugPrint('[API] NETWORK ERROR: $e');
      throw ApiException('Network error: $e');
    }

    debugPrint('[API] STATUS ${response.statusCode}');
    debugPrint('[API] BODY ${response.body.substring(0, response.body.length.clamp(0, 400))}');
    _checkStatus(response);

    try {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded is List
          ? decoded
          : (decoded as Map<String, dynamic>)['questions'] as List<dynamic>;
      return data.map((e) => Question.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      debugPrint('[API] PARSE ERROR: $e\n$st');
      throw ApiException('Parse error: $e');
    }
  }

  Future<Question> getDailyInsight() async {
    final uri = Uri.parse('$_baseUrl/questions/daily-insight');
    debugPrint('[API] GET $uri');

    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      debugPrint('[API] NETWORK ERROR: $e');
      throw ApiException('Network error: $e');
    }

    debugPrint('[API] STATUS ${response.statusCode}');
    debugPrint('[API] BODY ${response.body.substring(0, response.body.length.clamp(0, 400))}');
    _checkStatus(response);

    try {
      return Question.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e, st) {
      debugPrint('[API] PARSE ERROR: $e\n$st');
      throw ApiException('Parse error: $e');
    }
  }

  Future<Question> getQuestion(int id) async {
    final uri = Uri.parse('$_baseUrl/questions/$id');
    debugPrint('[API] GET $uri');

    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      debugPrint('[API] NETWORK ERROR: $e');
      throw ApiException('Network error: $e');
    }

    debugPrint('[API] STATUS ${response.statusCode}');
    _checkStatus(response);

    try {
      return Question.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e, st) {
      debugPrint('[API] PARSE ERROR: $e\n$st');
      throw ApiException('Parse error: $e');
    }
  }

  Future<HomeData> getHome(String deviceId) async {
    final uri = Uri.parse('$_baseUrl/home')
        .replace(queryParameters: {'device_id': deviceId});
    debugPrint('[API] GET $uri');
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
    _checkStatus(response);
    try {
      return HomeData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      throw ApiException('Parse error: $e');
    }
  }

  Future<List<Episode>> getEpisodes() async {
    final uri = Uri.parse('$_baseUrl/episodes');
    debugPrint('[API] GET $uri');
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
    _checkStatus(response);
    try {
      // Backend wraps: {"episodes": [...]}
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = decoded['episodes'] as List<dynamic>;
      return data.map((e) => Episode.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ApiException('Parse error: $e');
    }
  }

  Future<Episode> getEpisode(int id) async {
    final uri = Uri.parse('$_baseUrl/episodes/$id');
    debugPrint('[API] GET $uri');
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
    _checkStatus(response);
    try {
      return Episode.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      throw ApiException('Parse error: $e');
    }
  }

  Future<List<Question>> getEpisodeQuestions(int id) async {
    final uri = Uri.parse('$_baseUrl/episodes/$id/questions');
    debugPrint('[API] GET $uri');
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
    _checkStatus(response);
    try {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded is List
          ? decoded
          : (decoded as Map<String, dynamic>)['questions'] as List<dynamic>;
      return data.map((e) => Question.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ApiException('Parse error: $e');
    }
  }

  Future<DailyShloka> getDailyShloka({String deviceId = 'anonymous'}) async {
    final uri = Uri.parse('$_baseUrl/daily-shloka')
        .replace(queryParameters: {'device_id': deviceId});
    debugPrint('[API] GET $uri');
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
    _checkStatus(response);
    try {
      // Backend wraps: {"shloka": {...}} or {"shloka": null, "message": "..."}
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final shloka = decoded['shloka'];
      if (shloka == null) throw ApiException('No shlokas available');
      return DailyShloka.fromJson(shloka as Map<String, dynamic>);
    } catch (e) {
      throw ApiException('Parse error: $e');
    }
  }

  Future<JourneyData> getJourney(String deviceId) async {
    final uri = Uri.parse('$_baseUrl/journey')
        .replace(queryParameters: {'device_id': deviceId});
    debugPrint('[API] GET $uri');
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
    _checkStatus(response);
    try {
      return JourneyData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      throw ApiException('Parse error: $e');
    }
  }

  Future<List<SavedQuestion>> getSavedQuestions(String deviceId) async {
    final uri = Uri.parse('$_baseUrl/saved-questions')
        .replace(queryParameters: {'device_id': deviceId});
    debugPrint('[API] GET $uri');
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
    _checkStatus(response);
    try {
      // Backend wraps: {"count": N, "saved_questions": [...flat JOIN rows...]}
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = decoded['saved_questions'] as List<dynamic>;
      return data.map((e) => SavedQuestion.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ApiException('Parse error: $e');
    }
  }

  Future<void> saveQuestion(String deviceId, int questionId) async {
    final uri = Uri.parse('$_baseUrl/saved-questions');
    debugPrint('[API] POST $uri');
    final http.Response response;
    try {
      response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'device_id': deviceId, 'question_id': questionId}),
          )
          .timeout(_timeout);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
    _checkStatus(response);
  }

  Future<StoryInsight> getDailyStoryInsight() async {
    final uri = Uri.parse('$_baseUrl/insights/daily');
    debugPrint('[API] GET $uri');
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
    _checkStatus(response);
    try {
      return StoryInsight.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      throw ApiException('Parse error: $e');
    }
  }

  Future<List<PhaseSummary>> getPhases() async {
    final uri = Uri.parse('$_baseUrl/phases');
    debugPrint('[API] GET $uri');
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
    _checkStatus(response);
    try {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = decoded['phases'] as List<dynamic>;
      return data.map((e) => PhaseSummary.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ApiException('Parse error: $e');
    }
  }

  Future<PhaseStory> getPhaseStory(String storyPhase) async {
    final uri = Uri.parse('$_baseUrl/phases/${Uri.encodeComponent(storyPhase)}/story');
    debugPrint('[API] GET $uri');
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(_timeout);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
    _checkStatus(response);
    try {
      return PhaseStory.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      throw ApiException('Parse error: $e');
    }
  }

  Future<void> recordAnswer(String deviceId, int questionId, bool wasCorrect) async {
    final uri = Uri.parse('$_baseUrl/user-progress/answer');
    try {
      await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'device_id': deviceId,
              'question_id': questionId,
              'was_correct': wasCorrect,
            }),
          )
          .timeout(_timeout);
    } catch (e) {
      debugPrint('[API] recordAnswer failed (non-fatal): $e');
    }
  }

  Future<void> deleteSavedQuestion(int questionId, String deviceId) async {
    // Backend route: DELETE /saved-questions/{question_id} — uses question's ID, not saved record ID
    final uri = Uri.parse('$_baseUrl/saved-questions/$questionId')
        .replace(queryParameters: {'device_id': deviceId});
    debugPrint('[API] DELETE $uri');
    final http.Response response;
    try {
      response = await _client.delete(uri).timeout(_timeout);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
    _checkStatus(response);
  }

  void _checkStatus(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'Server error',
        statusCode: response.statusCode,
      );
    }
  }

  void dispose() => _client.close();
}
