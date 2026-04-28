class PhaseSummary {
  final String storyPhase;
  final String title;
  final String mood;
  final List<String> keyCharacters;

  const PhaseSummary({
    required this.storyPhase,
    required this.title,
    required this.mood,
    required this.keyCharacters,
  });

  factory PhaseSummary.fromJson(Map<String, dynamic> json) => PhaseSummary(
        storyPhase: (json['story_phase'] as String?) ?? '',
        title: (json['title'] as String?) ?? '',
        mood: (json['mood'] as String?) ?? '',
        keyCharacters: (json['key_characters'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );
}

class PhaseStory {
  final String storyPhase;
  final String title;
  final String narrative;
  final List<String> keyEvents;
  final List<String> keyCharacters;
  final String mood;
  final String shlokaWatermark;

  const PhaseStory({
    required this.storyPhase,
    required this.title,
    required this.narrative,
    required this.keyEvents,
    required this.keyCharacters,
    required this.mood,
    this.shlokaWatermark = 'रामो विग्रहवान् धर्मः',
  });

  factory PhaseStory.fromJson(Map<String, dynamic> json) => PhaseStory(
        storyPhase: (json['story_phase'] as String?) ?? '',
        title: (json['title'] as String?) ?? '',
        narrative: (json['narrative'] as String?) ?? '',
        keyEvents: (json['key_events'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        keyCharacters: (json['key_characters'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        mood: (json['mood'] as String?) ?? '',
        shlokaWatermark: (json['shloka_watermark'] as String?)?.isNotEmpty == true
            ? json['shloka_watermark'] as String
            : 'रामो विग्रहवान् धर्मः',
      );
}
