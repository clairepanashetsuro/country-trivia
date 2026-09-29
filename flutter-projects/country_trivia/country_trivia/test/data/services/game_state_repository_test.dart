import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_trivia/data/services/game_state_repository.dart';

void main() {
  group('GameStateRepositoryImpl', () {
    late GameStateRepositoryImpl repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      repository = GameStateRepositoryImpl();
    });

    test('getScore returns 0 when no score saved', () async {
      final score = await repository.getScore();

      expect(score, 0);
    });

    test('saveScore and getScore work correctly', () async {
      await repository.saveScore(100);

      final score = await repository.getScore();

      expect(score, 100);
    });

    test('saveScore overwrites previous score', () async {
      await repository.saveScore(50);
      await repository.saveScore(150);

      final score = await repository.getScore();

      expect(score, 150);
    });

    test('getSolvedIsoCodes returns empty list when none saved', () async {
      final solved = await repository.getSolvedIsoCodes();

      expect(solved, isEmpty);
    });

    test('saveSolvedIsoCodes and getSolvedIsoCodes work correctly', () async {
      await repository.saveSolvedIsoCodes(['DE', 'FR', 'ES']);

      final solved = await repository.getSolvedIsoCodes();

      expect(solved, ['DE', 'FR', 'ES']);
    });

    test('saveSolvedIsoCodes overwrites previous list', () async {
      await repository.saveSolvedIsoCodes(['DE', 'FR']);
      await repository.saveSolvedIsoCodes(['IT', 'PT', 'ES']);

      final solved = await repository.getSolvedIsoCodes();

      expect(solved, ['IT', 'PT', 'ES']);
    });

    test('clearAll removes both score and solved countries', () async {
      await repository.saveScore(200);
      await repository.saveSolvedIsoCodes(['DE', 'FR']);

      await repository.clearAll();

      final score = await repository.getScore();
      final solved = await repository.getSolvedIsoCodes();

      expect(score, 0);
      expect(solved, isEmpty);
    });
  });
}
