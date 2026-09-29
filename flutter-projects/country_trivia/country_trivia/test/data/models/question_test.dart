import 'package:flutter_test/flutter_test.dart';
import 'package:country_trivia/data/models/country.dart';
import 'package:country_trivia/data/models/question.dart';

void main() {
  group('Question', () {
    const correctAnswer = Country(name: 'Germany', isoCode: 'DE');
    const options = [
      Country(name: 'France', isoCode: 'FR'),
      Country(name: 'Germany', isoCode: 'DE'),
      Country(name: 'Spain', isoCode: 'ES'),
      Country(name: 'Italy', isoCode: 'IT'),
    ];

    test('isValid returns true when options has 4 items and includes correct answer', () {
      const question = Question(correctAnswer: correctAnswer, options: options);

      expect(question.isValid, isTrue);
    });

    test('isValid returns false when options has fewer than 4 items', () {
      const question = Question(
        correctAnswer: correctAnswer,
        options: [
          Country(name: 'France', isoCode: 'FR'),
          Country(name: 'Germany', isoCode: 'DE'),
        ],
      );

      expect(question.isValid, isFalse);
    });

    test('isValid returns false when correct answer is not in options', () {
      const question = Question(
        correctAnswer: correctAnswer,
        options: [
          Country(name: 'France', isoCode: 'FR'),
          Country(name: 'Spain', isoCode: 'ES'),
          Country(name: 'Italy', isoCode: 'IT'),
          Country(name: 'Portugal', isoCode: 'PT'),
        ],
      );

      expect(question.isValid, isFalse);
    });
  });
}
