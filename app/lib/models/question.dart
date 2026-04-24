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
      );

  static bool _parseBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) return v == '1' || v.toLowerCase() == 'true';
    return false;
  }

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
