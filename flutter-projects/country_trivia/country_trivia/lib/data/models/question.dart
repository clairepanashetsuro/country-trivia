import 'country.dart';

/// Represents a single trivia question with a correct answer and 4 options.
class Question {
  /// The correct country for this question
  final Country correctAnswer;

  /// List of 4 country options (including the correct answer), shuffled
  final List<Country> options;

  const Question({
    required this.correctAnswer,
    required this.options,
  });

  /// Validates that the question has exactly 4 options and includes the correct answer
  bool get isValid =>
      options.length == 4 && options.any((c) => c.isoCode == correctAnswer.isoCode);

  @override
  String toString() =>
      'Question(correctAnswer: ${correctAnswer.name}, options: ${options.map((o) => o.name).toList()})';
}
