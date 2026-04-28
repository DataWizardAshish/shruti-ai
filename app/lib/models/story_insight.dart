class StoryInsight {
  final int id;
  final String title;
  final String narrative;
  final String lesson;
  final String storyPhase;
  final String character;

  const StoryInsight({
    required this.id,
    required this.title,
    required this.narrative,
    required this.lesson,
    required this.storyPhase,
    required this.character,
  });

  factory StoryInsight.fromJson(Map<String, dynamic> json) => StoryInsight(
        id: (json['id'] as num).toInt(),
        title: (json['title'] as String?) ?? '',
        narrative: (json['narrative'] as String?) ?? '',
        lesson: (json['lesson'] as String?) ?? '',
        storyPhase: (json['story_phase'] as String?) ?? '',
        character: (json['character'] as String?) ?? '',
      );
}
