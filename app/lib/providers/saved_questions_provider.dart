import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question.dart';
import '../models/saved_question.dart';
import 'providers.dart';

@immutable
class SavedQuestionsState {
  final List<SavedQuestion> items;
  final bool isLoading;
  final String? error;
  final Set<int> savingIds;

  const SavedQuestionsState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.savingIds = const {},
  });

  bool isSaved(int questionId) =>
      items.any((s) => s.questionId == questionId);

  SavedQuestionsState copyWith({
    List<SavedQuestion>? items,
    bool? isLoading,
    String? error,
    Set<int>? savingIds,
  }) =>
      SavedQuestionsState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        savingIds: savingIds ?? this.savingIds,
      );
}

class SavedQuestionsNotifier extends StateNotifier<SavedQuestionsState> {
  SavedQuestionsNotifier(this._ref) : super(const SavedQuestionsState()) {
    Future.microtask(load);
  }

  final Ref _ref;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final progress = await _ref.read(progressServiceProvider.future);
      final items = progress
          .getSavedFavorites()
          .map((json) {
            try {
              return SavedQuestion.fromLocalJson(json);
            } catch (_) {
              return null;
            }
          })
          .whereType<SavedQuestion>()
          .toList()
          .reversed
          .toList();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> save(Question question) async {
    state = state.copyWith(savingIds: {...state.savingIds, question.id});
    try {
      final progress = await _ref.read(progressServiceProvider.future);
      final json = question.toJson()
        ..['saved_at'] = DateTime.now().toIso8601String();
      await progress.saveFavorite(json);
      await load();
      state = state.copyWith(savingIds: state.savingIds.difference({question.id}));
    } catch (e) {
      state = state.copyWith(
        savingIds: state.savingIds.difference({question.id}),
        error: e.toString(),
      );
    }
  }

  Future<void> unsave(int questionId) async {
    state = state.copyWith(savingIds: {...state.savingIds, questionId});
    try {
      final progress = await _ref.read(progressServiceProvider.future);
      await progress.unsaveFavorite(questionId);
      state = state.copyWith(
        items: state.items.where((s) => s.questionId != questionId).toList(),
        savingIds: state.savingIds.difference({questionId}),
      );
    } catch (e) {
      state = state.copyWith(
        savingIds: state.savingIds.difference({questionId}),
        error: e.toString(),
      );
    }
  }
}

final savedQuestionsProvider =
    StateNotifierProvider<SavedQuestionsNotifier, SavedQuestionsState>((ref) {
  return SavedQuestionsNotifier(ref);
});
