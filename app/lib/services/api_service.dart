import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/question.dart';

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
