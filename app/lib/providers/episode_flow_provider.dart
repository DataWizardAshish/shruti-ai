import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/episode.dart';
import '../models/question.dart';
import '../services/api_service.dart';
import 'providers.dart';

@immutable
class EpisodeFlowState {
  final Episode? activeEpisode;
  final List<Question> questions;
  final int currentIndex;
  final bool openingDismissed;
  final bool showClosing;
  final bool isLoading;
  final String? error;

  const EpisodeFlowState({
    this.activeEpisode,
    this.questions = const [],
    this.currentIndex = 0,
    this.openingDismissed = false,
    this.showClosing = false,
    this.isLoading = false,
    this.error,
  });

  EpisodeFlowState copyWith({
    Episode? activeEpisode,
    List<Question>? questions,
    int? currentIndex,
    bool? openingDismissed,
    bool? showClosing,
    bool? isLoading,
    String? error,
  }) =>
      EpisodeFlowState(
        activeEpisode: activeEpisode ?? this.activeEpisode,
        questions: questions ?? this.questions,
        currentIndex: currentIndex ?? this.currentIndex,
        openingDismissed: openingDismissed ?? this.openingDismissed,
        showClosing: showClosing ?? this.showClosing,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );

  bool get hasActiveEpisode => activeEpisode != null;
  bool get isComplete =>
      questions.isNotEmpty && currentIndex >= questions.length;
  Question? get currentQuestion =>
      questions.isNotEmpty && currentIndex < questions.length
          ? questions[currentIndex]
          : null;
}

class EpisodeFlowNotifier extends StateNotifier<EpisodeFlowState> {
  EpisodeFlowNotifier(this._api) : super(const EpisodeFlowState());

  final ApiService _api;

  void startEpisode(Episode episode) {
    state = EpisodeFlowState(activeEpisode: episode);
  }

  Future<void> dismissOpening() async {
    if (state.activeEpisode == null) return;
    state = state.copyWith(isLoading: true, openingDismissed: true);
    try {
      final questions = await _api.getEpisodeQuestions(state.activeEpisode!.id);
      state = state.copyWith(questions: questions, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void advance() {
    final next = state.currentIndex + 1;
    if (next >= state.questions.length) {
      state = state.copyWith(showClosing: true);
    } else {
      state = state.copyWith(currentIndex: next);
    }
  }

  void exitEpisode() {
    state = const EpisodeFlowState();
  }
}

final episodeFlowProvider =
    StateNotifierProvider<EpisodeFlowNotifier, EpisodeFlowState>((ref) {
  return EpisodeFlowNotifier(ref.watch(apiServiceProvider));
});
