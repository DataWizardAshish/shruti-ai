import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/progress_service.dart';
import '../models/question.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final service = ApiService();
  ref.onDispose(service.dispose);
  return service;
});

final progressServiceProvider = FutureProvider<ProgressService>((ref) async {
  return ProgressService.create();
});

final dailyInsightProvider = FutureProvider<Question>((ref) async {
  return ref.watch(apiServiceProvider).getDailyInsight();
});

final questionsProvider = FutureProvider.family<List<Question>, String>((ref, storyPhase) async {
  return ref.watch(apiServiceProvider).getQuestions(storyPhase: storyPhase, limit: 20);
});

final allQuestionsProvider = FutureProvider<List<Question>>((ref) async {
  return ref.watch(apiServiceProvider).getQuestions(limit: 100);
});
