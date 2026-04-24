import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _answeredKey = 'answered_question_ids';
  static const _correctKey = 'correct_question_ids';
  static const _lastActiveKey = 'last_active_date';
  static const _streakKey = 'streak_days';
  static const _onboardingKey = 'onboarding_complete';

  final SharedPreferences _prefs;

  ProgressService(this._prefs);

  static Future<ProgressService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ProgressService(prefs);
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
