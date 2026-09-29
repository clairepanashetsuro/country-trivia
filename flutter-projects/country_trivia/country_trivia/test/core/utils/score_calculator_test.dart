import 'package:flutter_test/flutter_test.dart';
import 'package:country_trivia/core/utils/score_calculator.dart';

void main() {
  group('ScoreCalculator', () {
    test('returns 10 points for first attempt', () {
      expect(ScoreCalculator.calculate(1), 10);
    });

    test('returns 8 points for second attempt', () {
      expect(ScoreCalculator.calculate(2), 8);
    });

    test('returns 5 points for third attempt', () {
      expect(ScoreCalculator.calculate(3), 5);
    });

    test('returns 0 points for fourth attempt (failed)', () {
      expect(ScoreCalculator.calculate(4), 0);
    });

    test('returns 0 points for attempt greater than 4', () {
      expect(ScoreCalculator.calculate(5), 0);
      expect(ScoreCalculator.calculate(10), 0);
    });

    test('returns 0 points for zero attempt', () {
      expect(ScoreCalculator.calculate(0), 0);
    });

    test('returns 0 points for negative attempt', () {
      expect(ScoreCalculator.calculate(-1), 0);
    });
  });
}
