class Episode {
  final int id;
  final String name;
  final String kanda;
  final String storyPhase;
  final String subtitle;
  final String openingText;
  final String closingText;
  final String emotionalTone;
  final int questionsCount;

  const Episode({
    required this.id,
    required this.name,
    required this.kanda,
    required this.storyPhase,
    required this.subtitle,
    required this.openingText,
    required this.closingText,
    required this.emotionalTone,
    required this.questionsCount,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        id: (json['id'] as num).toInt(),
        name: (json['episode_name'] as String?) ?? '',
        kanda: (json['kanda'] as String?) ?? '',
        storyPhase: (json['story_phase'] as String?) ?? '',
        subtitle: (json['episode_subtitle'] as String?) ?? '',
        openingText: (json['opening_text'] as String?) ?? '',
        closingText: (json['closing_text'] as String?) ?? '',
        emotionalTone: (json['emotional_tone'] as String?) ?? '',
        questionsCount: (json['question_count'] as num?)?.toInt() ?? 0,
      );
}
