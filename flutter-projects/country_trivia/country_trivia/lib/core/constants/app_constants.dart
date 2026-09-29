/// General application constants.
class AppConstants {
  AppConstants._();

  // Storage keys (must match GameStateRepositoryImpl)
  static const String scoreKey = 'game_score';
  static const String solvedKey = 'solved_countries';

  // Gameplay
  static const int maxAttempts = 3;
  static const int optionsPerQuestion = 4;

  // Scoring (mirror of ScoreCalculator; single source of truth is that class)
  static const int firstAttemptPoints = 10;
  static const int secondAttemptPoints = 8;
  static const int thirdAttemptPoints = 5;
  static const int failedPoints = 0;

  // Animation durations
  static const Duration feedbackDisplayDuration = Duration(milliseconds: 1500);
  static const Duration optionTransitionDuration = Duration(milliseconds: 250);
  static const Duration screenTransitionDuration = Duration(milliseconds: 300);

  // Layout
  static const double flagWidth = 320;
  static const double spacingSmall = 8;
  static const double spacingMedium = 16;
  static const double spacingLarge = 24;
  static const double cornerRadius = 12;
}
