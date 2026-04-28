// Matches build_journey_response() in services/journey_calculator.py
class CurrentPosition {
  final String kanda;
  final String episodeName;
  final int episodeSequence;
  final double progressPercent;

  const CurrentPosition({
    required this.kanda,
    required this.episodeName,
    required this.episodeSequence,
    required this.progressPercent,
  });

  factory CurrentPosition.fromJson(Map<String, dynamic> json) =>
      CurrentPosition(
        kanda: (json['kanda'] as String?) ?? '',
        episodeName: (json['episode_name'] as String?) ?? '',
        episodeSequence: (json['episode_sequence'] as num?)?.toInt() ?? 1,
        progressPercent:
            (json['progress_within_episode_percent'] as num?)?.toDouble() ?? 0,
      );
}

class JourneyData {
  final CurrentPosition currentPosition;
  final List<String> milestonesReached;
  final String nextMilestone;
  final String weekSummary;
  final String mood;

  const JourneyData({
    required this.currentPosition,
    required this.milestonesReached,
    required this.nextMilestone,
    required this.weekSummary,
    required this.mood,
  });

  factory JourneyData.fromJson(Map<String, dynamic> json) => JourneyData(
        currentPosition: CurrentPosition.fromJson(
            json['current_position'] as Map<String, dynamic>),
        milestonesReached: (json['milestones_reached'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        nextMilestone: (json['next_milestone'] as String?) ?? '',
        weekSummary: (json['week_summary'] as String?) ?? '',
        mood: (json['mood'] as String?) ?? '',
      );
}
