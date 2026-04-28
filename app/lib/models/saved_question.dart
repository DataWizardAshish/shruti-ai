import 'question.dart';

class SavedQuestion {
  final int id;          // saved_questions.id (PK of saved record)
  final int questionId;  // the question's ID
  final Question question;
  final DateTime savedAt;

  const SavedQuestion({
    required this.id,
    required this.questionId,
    required this.question,
    required this.savedAt,
  });

  // Backend returns flat JOIN row: saved_id, saved_at, user_note, q.*
  // No nested question object — all question columns are inline.
  factory SavedQuestion.fromJson(Map<String, dynamic> json) => SavedQuestion(
        id: (json['saved_id'] as num).toInt(),
        questionId: (json['question_id'] as num).toInt(),
        question: Question.fromJson(json),
        savedAt: DateTime.parse(json['saved_at'] as String),
      );

  // Local storage: question JSON with added 'saved_at' key
  factory SavedQuestion.fromLocalJson(Map<String, dynamic> json) {
    final questionId = (json['id'] as num).toInt();
    return SavedQuestion(
      id: questionId,
      questionId: questionId,
      question: Question.fromJson(json),
      savedAt: json['saved_at'] != null
          ? DateTime.tryParse(json['saved_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
