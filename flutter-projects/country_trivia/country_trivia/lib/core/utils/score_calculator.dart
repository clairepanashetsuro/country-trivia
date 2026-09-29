/// Utility class for calculating points based on attempt number.
class ScoreCalculator {
  ScoreCalculator._();

  /// Points awarded for each attempt number
  static const int firstAttemptPoints = 10;
  static const int secondAttemptPoints = 8;
  static const int thirdAttemptPoints = 5;
  static const int failedPoints = 0;

  /// Calculates points based on the attempt number.
  ///
  /// - 1st attempt: 10 points
  /// - 2nd attempt: 8 points
  /// - 3rd attempt: 5 points
  /// - 4th+ attempt (failed): 0 points
  static int calculate(int attempt) {
    switch (attempt) {
      case 1:
        return firstAttemptPoints;
      case 2:
        return secondAttemptPoints;
      case 3:
        return thirdAttemptPoints;
      default:
        return failedPoints;
    }
  }
}
