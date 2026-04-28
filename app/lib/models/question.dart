class Question {
  final int id;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer;
  final String explanation;
  final String difficulty;
  final String topic;
  final String storyPhase;
  final String narrativeArc;
  final String chapterTitle;
  final int engagementScore;
  final bool isDailyInsight;
  final DateTime? approvedAt;
  final String? sceneSetup;
  final String? narrativeContinuation;
  final String? deepContext;
  final String? forwardHook;

  const Question({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    required this.explanation,
    required this.difficulty,
    required this.topic,
    required this.storyPhase,
    required this.narrativeArc,
    required this.chapterTitle,
    required this.engagementScore,
    required this.isDailyInsight,
    this.approvedAt,
    this.sceneSetup,
    this.narrativeContinuation,
    this.deepContext,
    this.forwardHook,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: (json['id'] as num).toInt(),
        question: json['question'] as String,
        optionA: json['option_a'] as String,
        optionB: json['option_b'] as String,
        optionC: json['option_c'] as String,
        optionD: json['option_d'] as String,
        correctAnswer: json['correct_answer'] as String,
        explanation: json['explanation'] as String,
        difficulty: json['difficulty'] as String,
        topic: (json['topic'] as String?) ?? '',
        storyPhase: (json['story_phase'] as String?) ?? 'Other',
        narrativeArc: (json['narrative_arc'] as String?) ?? '',
        chapterTitle: (json['chapter_title'] as String?) ?? '',
        engagementScore: (json['engagement_score'] as num?)?.toInt() ?? 0,
        isDailyInsight: _parseBool(json['is_daily_insight']),
        approvedAt: json['approved_at'] != null
            ? DateTime.tryParse(json['approved_at'] as String)
            : null,
        sceneSetup: json['scene_setup'] as String?,
        narrativeContinuation: json['narrative_continuation'] as String?,
        deepContext: json['deep_context'] as String?,
        forwardHook: json['forward_hook'] as String?,
      );

  static bool _parseBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) return v == '1' || v.toLowerCase() == 'true';
    return false;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'option_a': optionA,
        'option_b': optionB,
        'option_c': optionC,
        'option_d': optionD,
        'correct_answer': correctAnswer,
        'explanation': explanation,
        'difficulty': difficulty,
        'topic': topic,
        'story_phase': storyPhase,
        'narrative_arc': narrativeArc,
        'chapter_title': chapterTitle,
        'engagement_score': engagementScore,
        'is_daily_insight': isDailyInsight,
        if (approvedAt != null) 'approved_at': approvedAt!.toIso8601String(),
        if (sceneSetup != null) 'scene_setup': sceneSetup,
        if (narrativeContinuation != null)
          'narrative_continuation': narrativeContinuation,
        if (deepContext != null) 'deep_context': deepContext,
        if (forwardHook != null) 'forward_hook': forwardHook,
      };

  Map<String, String> get options => {
        'A': optionA,
        'B': optionB,
        'C': optionC,
        'D': optionD,
      };

  bool isCorrect(String answer) => answer == correctAnswer;
}

const storyPhases = [
  'Early Life of Rama',
  'Exile Phase',
  'Sita Haran',
  'Search for Sita',
  'Lanka War',
  'Return and Reunion',
  'Other',
];
