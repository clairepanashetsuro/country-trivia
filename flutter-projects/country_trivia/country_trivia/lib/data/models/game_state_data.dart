import 'question.dart';
import '../enums/game_state.dart';

/// Sentinel used by [GameStateData.copyWith] to distinguish "argument omitted"
/// from "explicitly set to null".
///
/// Without this, `x ?? this.x` makes it impossible to clear a nullable field:
/// passing `null` would silently keep the old value.
const Object _unset = Object();

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

  /// Creates a copy of this state with optionally updated fields.
  ///
  /// Omitted arguments keep their current value. Passing `null` explicitly
  /// for a nullable field clears it — see [_unset] for why this needs a
  /// sentinel rather than a plain `??`.
  GameStateData copyWith({
    GameState? state,
    Object? currentQuestion = _unset,
    int? score,
    int? attempts,
    int? currentStreak,
    int? totalSolved,
    int? totalCountries,
    Object? lastAnswerCorrect = _unset,
    Object? lastPointsEarned = _unset,
  }) {
    return GameStateData(
      state: state ?? this.state,
      currentQuestion: identical(currentQuestion, _unset)
          ? this.currentQuestion
          : currentQuestion as Question?,
      score: score ?? this.score,
      attempts: attempts ?? this.attempts,
      currentStreak: currentStreak ?? this.currentStreak,
      totalSolved: totalSolved ?? this.totalSolved,
      totalCountries: totalCountries ?? this.totalCountries,
      lastAnswerCorrect: identical(lastAnswerCorrect, _unset)
          ? this.lastAnswerCorrect
          : lastAnswerCorrect as bool?,
      lastPointsEarned: identical(lastPointsEarned, _unset)
          ? this.lastPointsEarned
          : lastPointsEarned as int?,
    );
  }

  @override
  String toString() =>
      'GameStateData(state: $state, score: $score, attempts: $attempts, totalSolved: $totalSolved/$totalCountries)';
}
