import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/progress_service.dart';
import '../models/question.dart';
import '../models/story_insight.dart';
import '../models/phase_story.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final service = ApiService();
  ref.onDispose(service.dispose);
  return service;
});

final progressServiceProvider = FutureProvider<ProgressService>((ref) async {
  return ProgressService.create();
});

final dailyInsightProvider = FutureProvider<StoryInsight>((ref) async {
  return ref.watch(apiServiceProvider).getDailyStoryInsight();
});

final phasesProvider = FutureProvider<List<PhaseSummary>>((ref) async {
  return ref.watch(apiServiceProvider).getPhases();
});

final phaseStoryProvider =
    FutureProvider.family<PhaseStory, String>((ref, storyPhase) async {
  return ref.watch(apiServiceProvider).getPhaseStory(storyPhase);
});

final questionsProvider = FutureProvider.family<List<Question>, String>((ref, storyPhase) async {
  return ref.watch(apiServiceProvider).getQuestions(storyPhase: storyPhase, limit: 20);
});

final allQuestionsProvider = FutureProvider<List<Question>>((ref) async {
  return ref.watch(apiServiceProvider).getQuestions(limit: 100);
});

final episodeQuestionsProvider =
    FutureProvider.family<List<Question>, int>((ref, episodeId) async {
  return ref.watch(apiServiceProvider).getEpisodeQuestions(episodeId);
});

final deviceIdProvider = FutureProvider<String>((ref) async {
  final progress = await ref.watch(progressServiceProvider.future);
  return progress.getOrCreateDeviceId();
});
