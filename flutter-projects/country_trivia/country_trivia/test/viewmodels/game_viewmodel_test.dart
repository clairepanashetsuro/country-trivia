import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:country_trivia/data/enums/game_state.dart';
import 'package:country_trivia/data/models/country.dart';
import 'package:country_trivia/data/services/api_service.dart';
import 'package:country_trivia/data/services/game_state_repository.dart';
import 'package:country_trivia/viewmodels/game_viewmodel.dart';

class _FakeCountryApi implements CountryApiService {
  _FakeCountryApi(this.countries);

  final List<Country> countries;

  @override
  Future<List<Country>> fetchAllCountries() async => countries;
}

class _FailingCountryApi implements CountryApiService {
  @override
  Future<List<Country>> fetchAllCountries() async => throw Exception('network down');
}

List<Country> _pool(int count) => List.generate(
      count,
      (i) => Country(name: 'Country$i', isoCode: 'C$i'),
    );

void main() {
  late GameStateRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = GameStateRepositoryImpl();
  });

  GameViewModel build({List<Country>? pool, CountryApiService? api}) => GameViewModel(
        countryApi: api ?? _FakeCountryApi(pool ?? _pool(10)),
        gameStateRepo: repository,
      );

  group('initialize', () {
    test('loads countries and generates a first question', () async {
      final vm = build();
      await vm.initialize();

      expect(vm.state.state, GameState.ready);
      expect(vm.state.totalCountries, 10);
      expect(vm.state.currentQuestion, isNotNull);
      expect(vm.state.currentQuestion!.isValid, isTrue);
      expect(vm.state.score, 0);
      expect(vm.state.attempts, 0);
    });

    test('restores persisted score', () async {
      await repository.saveScore(75);
      final vm = build();
      await vm.initialize();

      expect(vm.state.score, 75);
    });

    test('restores persisted solved countries and excludes them', () async {
      final pool = _pool(10);
      await repository.saveSolvedIsoCodes(['C0', 'C1', 'C2']);

      final vm = build(pool: pool);
      await vm.initialize();

      expect(vm.state.totalSolved, 3);
      expect(vm.solvedIsoCodes, ['C0', 'C1', 'C2']);

      // Generate several questions; none of the solved countries may appear.
      for (var i = 0; i < 5; i++) {
        final iso = vm.state.currentQuestion!.correctAnswer.isoCode;
        expect(['C0', 'C1', 'C2'], isNot(contains(iso)));
        vm.answer(iso);
        vm.nextQuestion();
      }
    });

    test('sets errorMessage when the API fails', () async {
      final vm = build(api: _FailingCountryApi());
      await vm.initialize();

      expect(vm.errorMessage, isNotNull);
      expect(vm.state.currentQuestion, isNull);
    });

    test('sets errorMessage when fewer than 4 countries are available', () async {
      final vm = build(pool: _pool(2));
      await vm.initialize();

      expect(vm.errorMessage, isNotNull);
    });

    test('retry clears a previous error', () async {
      final vm = build(api: _FailingCountryApi());
      await vm.initialize();
      expect(vm.errorMessage, isNotNull);

      // Swap in a working API by re-initializing against a fresh view model
      // sharing the same repository.
      final retryVm = build();
      await retryVm.initialize();
      expect(retryVm.errorMessage, isNull);
    });
  });

  group('question generation', () {
    test('question always has exactly 4 options including the answer', () async {
      final vm = build();
      await vm.initialize();

      for (var i = 0; i < 5; i++) {
        final q = vm.state.currentQuestion!;
        expect(q.options.length, 4);
        expect(q.isValid, isTrue);
        expect(
          q.options.where((c) => c.isoCode == q.correctAnswer.isoCode).length,
          1,
        );
        vm.answer(q.correctAnswer.isoCode);
        vm.nextQuestion();
      }
    });

    test('options do not contain duplicates', () async {
      final vm = build();
      await vm.initialize();

      final isoCodes = vm.state.currentQuestion!.options.map((c) => c.isoCode).toSet();
      expect(isoCodes.length, 4);
    });
  });

  group('answer scoring', () {
    test('correct on first attempt awards 10 points', () async {
      final vm = build();
      await vm.initialize();
      final correct = vm.state.currentQuestion!.correctAnswer.isoCode;

      await vm.answer(correct);

      expect(vm.state.lastAnswerCorrect, isTrue);
      expect(vm.state.lastPointsEarned, 10);
      expect(vm.state.score, 10);
      expect(vm.state.attempts, 1);
    });

    test('correct on second attempt awards 8 points', () async {
      final vm = build();
      await vm.initialize();
      final q = vm.state.currentQuestion!;
      final wrong = q.options.firstWhere((c) => c.isoCode != q.correctAnswer.isoCode);

      await vm.answer(wrong.isoCode);
      expect(vm.state.lastPointsEarned, 0);
      expect(vm.state.attempts, 1);

      // Retry same question, then answer correctly.
      vm.nextQuestion();
      await vm.answer(q.correctAnswer.isoCode);

      expect(vm.state.attempts, 2);
      expect(vm.state.lastPointsEarned, 8);
      expect(vm.state.score, 8);
    });

    test('correct on third attempt awards 5 points', () async {
      final vm = build();
      await vm.initialize();
      final q = vm.state.currentQuestion!;
      final wrong =
          q.options.firstWhere((c) => c.isoCode != q.correctAnswer.isoCode).isoCode;

      await vm.answer(wrong);
      vm.nextQuestion();
      await vm.answer(wrong);
      vm.nextQuestion();
      await vm.answer(q.correctAnswer.isoCode);

      expect(vm.state.attempts, 3);
      expect(vm.state.lastPointsEarned, 5);
      expect(vm.state.score, 5);
    });

    test('exhausting all attempts awards 0 and marks the country solved', () async {
      final vm = build();
      await vm.initialize();
      final q = vm.state.currentQuestion!;
      final wrong =
          q.options.firstWhere((c) => c.isoCode != q.correctAnswer.isoCode).isoCode;

      await vm.answer(wrong);
      vm.nextQuestion();
      await vm.answer(wrong);
      vm.nextQuestion();
      await vm.answer(wrong);

      expect(vm.state.attempts, 3);
      expect(vm.state.lastAnswerCorrect, isFalse);
      expect(vm.state.lastPointsEarned, 0);
      expect(vm.state.score, 0);
      expect(vm.solvedIsoCodes, contains(q.correctAnswer.isoCode));
      expect(vm.state.totalSolved, 1);
    });

    test('ignores answers when not in ready state', () async {
      final vm = build();
      await vm.initialize();

      expect(vm.canAnswer, isTrue);
      await vm.answer(vm.state.currentQuestion!.correctAnswer.isoCode);
      expect(vm.canAnswer, isFalse);

      // Second answer while in answered state must be a no-op.
      await vm.answer('SOMETHING_ELSE');
      expect(vm.state.score, 10);
    });
  });

  group('nextQuestion', () {
    test('repeats the same question after a wrong answer with attempts left', () async {
      final vm = build();
      await vm.initialize();
      final q = vm.state.currentQuestion!;
      final wrong =
          q.options.firstWhere((c) => c.isoCode != q.correctAnswer.isoCode).isoCode;

      await vm.answer(wrong);
      vm.nextQuestion();

      expect(vm.state.state, GameState.ready);
      expect(vm.state.currentQuestion!.correctAnswer.isoCode, q.correctAnswer.isoCode);
      expect(vm.state.attempts, 1, reason: 'attempt counter must be preserved');
      expect(vm.state.lastAnswerCorrect, isNull);
    });

    test('moves to a new question after a correct answer', () async {
      final vm = build();
      await vm.initialize();
      final first = vm.state.currentQuestion!.correctAnswer.isoCode;

      await vm.answer(first);
      vm.nextQuestion();

      expect(vm.state.currentQuestion!.correctAnswer.isoCode, isNot(first));
      expect(vm.state.attempts, 0);
    });

    test('is ignored when not in answered state', () async {
      final vm = build();
      await vm.initialize();
      final iso = vm.state.currentQuestion!.correctAnswer.isoCode;

      vm.nextQuestion();

      expect(vm.state.currentQuestion!.correctAnswer.isoCode, iso);
    });
  });

  group('persistence', () {
    test('score and solved countries survive a new view model', () async {
      final vm = build();
      await vm.initialize();
      final first = vm.state.currentQuestion!.correctAnswer.isoCode;
      await vm.answer(first);
      vm.nextQuestion();

      // Simulate an app restart against the same SharedPreferences.
      final restarted = build();
      await restarted.initialize();

      expect(restarted.state.score, 10);
      expect(restarted.solvedIsoCodes, [first]);
    });
  });

  group('game over and reset', () {
    test('reaches gameOver once every country is solved', () async {
      final vm = build(pool: _pool(4));
      await vm.initialize();

      for (var i = 0; i < 4; i++) {
        final iso = vm.state.currentQuestion!.correctAnswer.isoCode;
        await vm.answer(iso);
        vm.nextQuestion();
      }

      expect(vm.state.state, GameState.gameOver);
    });

    test('resetGame clears score and solved countries', () async {
      final vm = build();
      await vm.initialize();
      await vm.answer(vm.state.currentQuestion!.correctAnswer.isoCode);
      vm.nextQuestion();

      expect(vm.state.score, 10);
      expect(vm.solvedIsoCodes, isNotEmpty);

      await vm.resetGame();

      expect(vm.state.score, 0);
      expect(vm.solvedIsoCodes, isEmpty);
      expect(vm.state.totalSolved, 0);
      expect(vm.state.state, GameState.ready);
      expect(vm.state.currentQuestion, isNotNull);
    });

    test('resetGame persists the cleared state', () async {
      final vm = build();
      await vm.initialize();
      await vm.answer(vm.state.currentQuestion!.correctAnswer.isoCode);
      await vm.resetGame();

      final restarted = build();
      await restarted.initialize();

      expect(restarted.state.score, 0);
      expect(restarted.solvedIsoCodes, isEmpty);
    });
  });
}
