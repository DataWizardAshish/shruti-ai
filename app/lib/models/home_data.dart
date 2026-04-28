import 'daily_shloka.dart';
import 'story_insight.dart';

class HomeData {
  final String greeting;
  final DailyShloka? dailyShloka;
  final StoryInsight? dailyInsight;
  final int? currentEpisodeId;
  final String? currentEpisodeName;
  final int? questionsRemaining;

  const HomeData({
    required this.greeting,
    this.dailyShloka,
    this.dailyInsight,
    this.currentEpisodeId,
    this.currentEpisodeName,
    this.questionsRemaining,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    DailyShloka? shloka;
    if (json['daily_shloka'] != null) {
      shloka = DailyShloka.fromJson(json['daily_shloka'] as Map<String, dynamic>);
    }

    StoryInsight? insight;
    if (json['daily_insight'] != null) {
      insight = StoryInsight.fromJson(json['daily_insight'] as Map<String, dynamic>);
    }

    int? episodeId;
    String? episodeName;
    int? qRemaining;
    if (json['continue_journey'] != null) {
      final cj = json['continue_journey'] as Map<String, dynamic>;
      episodeId = (cj['current_episode_id'] as num?)?.toInt();
      episodeName = cj['episode_name'] as String?;
      qRemaining = (cj['questions_remaining'] as num?)?.toInt();
    }

    return HomeData(
      greeting: (json['greeting'] as String?) ?? 'Welcome, traveler',
      dailyShloka: shloka,
      dailyInsight: insight,
      currentEpisodeId: episodeId,
      currentEpisodeName: episodeName,
      questionsRemaining: qRemaining,
    );
  }
}
