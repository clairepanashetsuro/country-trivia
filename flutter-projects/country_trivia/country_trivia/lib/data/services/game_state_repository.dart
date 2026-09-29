import 'package:shared_preferences/shared_preferences.dart';

/// Abstract interface for persisting game state.
abstract class GameStateRepository {
  /// Retrieves the saved score.
  Future<int> getScore();

  /// Saves the current score.
  Future<void> saveScore(int score);

  /// Retrieves the list of solved country ISO codes.
  Future<List<String>> getSolvedIsoCodes();

  /// Saves the list of solved country ISO codes.
  Future<void> saveSolvedIsoCodes(List<String> isoCodes);

  /// Clears all persisted game state.
  Future<void> clearAll();
}

/// Implementation of [GameStateRepository] using SharedPreferences.
class GameStateRepositoryImpl implements GameStateRepository {
  static const _scoreKey = 'game_score';
  static const _solvedKey = 'solved_countries';

  @override
  Future<int> getScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_scoreKey) ?? 0;
  }

  @override
  Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_scoreKey, score);
  }

  @override
  Future<List<String>> getSolvedIsoCodes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_solvedKey) ?? [];
  }

  @override
  Future<void> saveSolvedIsoCodes(List<String> isoCodes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_solvedKey, isoCodes);
  }

  @override
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scoreKey);
    await prefs.remove(_solvedKey);
  }
}
