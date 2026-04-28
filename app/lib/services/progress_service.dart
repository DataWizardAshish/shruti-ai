import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ProgressService {
  static const _answeredKey = 'answered_question_ids';
  static const _correctKey = 'correct_question_ids';
  static const _lastActiveKey = 'last_active_date';
  static const _streakKey = 'streak_days';
  static const _onboardingKey = 'onboarding_complete';
  static const _deviceIdKey = 'device_id';
  static const _savedFavoritesKey = 'saved_favorites_json';

  final SharedPreferences _prefs;

  ProgressService(this._prefs);

  static Future<ProgressService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ProgressService(prefs);
  }

  // Device ID

  // Saved favorites (local-only, no backend required)

  bool isFavorite(int questionId) {
    return (_prefs.getStringList(_savedFavoritesKey) ?? []).any((s) {
      try {
        return (jsonDecode(s)['id'] as num).toInt() == questionId;
      } catch (_) {
        return false;
      }
    });
  }

  Future<void> saveFavorite(Map<String, dynamic> questionJson) async {
    final id = (questionJson['id'] as num).toInt();
    if (isFavorite(id)) return;
    final data = List<String>.from(
        _prefs.getStringList(_savedFavoritesKey) ?? []);
    data.add(jsonEncode(questionJson));
    await _prefs.setStringList(_savedFavoritesKey, data);
  }

  Future<void> unsaveFavorite(int questionId) async {
    final data = (_prefs.getStringList(_savedFavoritesKey) ?? []).where((s) {
      try {
        return (jsonDecode(s)['id'] as num).toInt() != questionId;
      } catch (_) {
        return true;
      }
    }).toList();
    await _prefs.setStringList(_savedFavoritesKey, data);
  }

  List<Map<String, dynamic>> getSavedFavorites() {
    return (_prefs.getStringList(_savedFavoritesKey) ?? [])
        .map((s) {
          try {
            return jsonDecode(s) as Map<String, dynamic>?;
          } catch (_) {
            return null;
          }
        })
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  // Device ID

  Future<String> getOrCreateDeviceId() async {
    final existing = _prefs.getString(_deviceIdKey);
    if (existing != null) return existing;
    final newId = const Uuid().v4();
    await _prefs.setString(_deviceIdKey, newId);
    return newId;
  }

  // Onboarding

  bool get onboardingComplete => _prefs.getBool(_onboardingKey) ?? false;

  Future<void> completeOnboarding() => _prefs.setBool(_onboardingKey, true);

  // Question progress

  Set<int> get answeredIds =>
      (_prefs.getStringList(_answeredKey) ?? []).map(int.parse).toSet();

  Set<int> get correctIds =>
      (_prefs.getStringList(_correctKey) ?? []).map(int.parse).toSet();

  bool isAnswered(int id) => answeredIds.contains(id);

  bool isCorrect(int id) => correctIds.contains(id);

  Future<void> recordAnswer(int id, {required bool correct}) async {
    final answered = answeredIds..add(id);
    await _prefs.setStringList(_answeredKey, answered.map((e) => e.toString()).toList());

    if (correct) {
      final corrects = correctIds..add(id);
      await _prefs.setStringList(_correctKey, corrects.map((e) => e.toString()).toList());
    }

    await _updateStreak();
  }

  // Phase progress: returns answered count for a given story phase
  // (requires caller to pass all question IDs for that phase)
  int answeredCountForIds(List<int> phaseQuestionIds) =>
      phaseQuestionIds.where(isAnswered).length;

  // Streak

  int get streakDays => _prefs.getInt(_streakKey) ?? 0;

  Future<void> _updateStreak() async {
    final today = _todayString();
    final lastActive = _prefs.getString(_lastActiveKey);

    if (lastActive == today) return;

    final yesterday = _yesterdayString();
    final newStreak = lastActive == yesterday ? streakDays + 1 : 1;

    await _prefs.setInt(_streakKey, newStreak);
    await _prefs.setString(_lastActiveKey, today);
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _yesterdayString() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
  }

  Future<void> clearAll() => _prefs.clear();
}
