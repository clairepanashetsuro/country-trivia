import 'question.dart';
import '../enums/game_state.dart';

/// Immutable data class representing the complete game state.
class GameStateData {
  /// Current game state
  final GameState state;

  /// Current question (null if no question generated yet)
  final Question? currentQuestion;

  /// Total score accumulated
  final int score;

  /// Number of attempts made on current question (0-3)
  final int attempts;

  /// Current consecutive correct answers streak
  final int currentStreak;

  /// Total number of countries solved
  final int totalSolved;

  /// Total number of countries available
  final int totalCountries;

  /// Whether the last answer was correct (null if no answer yet)
  final bool? lastAnswerCorrect;

  /// Points earned from last answer (null if no answer yet)
  final int? lastPointsEarned;

  const GameStateData({
    this.state = GameState.loading,
    this.currentQuestion,
    this.score = 0,
    this.attempts = 0,
    this.currentStreak = 0,
    this.totalSolved = 0,
    this.totalCountries = 0,
    this.lastAnswerCorrect,
    this.lastPointsEarned,
  });

  /// Creates a copy of this state with optionally updated fields
  GameStateData copyWith({
    GameState? state,
    Question? currentQuestion,
    int? score,
    int? attempts,
    int? currentStreak,
    int? totalSolved,
    int? totalCountries,
    bool? lastAnswerCorrect,
    int? lastPointsEarned,
  }) {
    return GameStateData(
      state: state ?? this.state,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      score: score ?? this.score,
      attempts: attempts ?? this.attempts,
      currentStreak: currentStreak ?? this.currentStreak,
      totalSolved: totalSolved ?? this.totalSolved,
      totalCountries: totalCountries ?? this.totalCountries,
      lastAnswerCorrect: lastAnswerCorrect ?? this.lastAnswerCorrect,
      lastPointsEarned: lastPointsEarned ?? this.lastPointsEarned,
    );
  }

  @override
  String toString() =>
      'GameStateData(state: $state, score: $score, attempts: $attempts, totalSolved: $totalSolved/$totalCountries)';
}
