import 'package:flutter_test/flutter_test.dart';
import 'package:country_trivia/data/models/game_state_data.dart';
import 'package:country_trivia/data/models/question.dart';
import 'package:country_trivia/data/models/country.dart';
import 'package:country_trivia/data/enums/game_state.dart';

void main() {
  group('GameStateData', () {
    const question = Question(
      correctAnswer: Country(name: 'Germany', isoCode: 'DE'),
      options: [
        Country(name: 'France', isoCode: 'FR'),
        Country(name: 'Germany', isoCode: 'DE'),
        Country(name: 'Spain', isoCode: 'ES'),
        Country(name: 'Italy', isoCode: 'IT'),
      ],
    );

    test('has correct default values', () {
      const state = GameStateData();

      expect(state.state, GameState.loading);
      expect(state.currentQuestion, isNull);
      expect(state.score, 0);
      expect(state.attempts, 0);
      expect(state.currentStreak, 0);
      expect(state.totalSolved, 0);
      expect(state.totalCountries, 0);
      expect(state.lastAnswerCorrect, isNull);
      expect(state.lastPointsEarned, isNull);
    });

    test('copyWith updates only specified fields', () {
      const original = GameStateData(
        state: GameState.ready,
        score: 50,
        attempts: 1,
      );

      final updated = original.copyWith(
        score: 60,
        attempts: 2,
      );

      expect(updated.state, GameState.ready);
      expect(updated.score, 60);
      expect(updated.attempts, 2);
      expect(updated.currentQuestion, isNull);
      expect(updated.totalSolved, 0);
    });

    test('copyWith can update currentQuestion', () {
      const original = GameStateData(state: GameState.ready);

      final updated = original.copyWith(currentQuestion: question);

      expect(updated.currentQuestion, question);
    });

    test('copyWith can update lastAnswerCorrect and lastPointsEarned', () {
      const original = GameStateData(state: GameState.answered);

      final updated = original.copyWith(
        lastAnswerCorrect: true,
        lastPointsEarned: 10,
      );

      expect(updated.lastAnswerCorrect, isTrue);
      expect(updated.lastPointsEarned, 10);
    });

    test('copyWith preserves unspecified fields', () {
      const original = GameStateData(
        state: GameState.ready,
        currentQuestion: question,
        score: 100,
        attempts: 2,
        currentStreak: 5,
        totalSolved: 10,
        totalCountries: 195,
      );

      final updated = original.copyWith(score: 110);

      expect(updated.state, GameState.ready);
      expect(updated.currentQuestion, question);
      expect(updated.score, 110);
      expect(updated.attempts, 2);
      expect(updated.currentStreak, 5);
      expect(updated.totalSolved, 10);
      expect(updated.totalCountries, 195);
    });
  });
}
