import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/score_calculator.dart';
import '../data/enums/game_state.dart';
import '../data/models/country.dart';
import '../data/models/game_state_data.dart';
import '../data/models/question.dart';
import '../data/services/api_service.dart';
import '../data/services/game_state_repository.dart';

/// Single source of truth for game state. Exposes commands the UI can invoke
/// and notifies listeners on every mutation.
class GameViewModel extends ChangeNotifier {
  final CountryApiService _countryApi;
  final GameStateRepository _gameStateRepo;

  GameStateData _state = const GameStateData();
  List<Country> _allCountries = [];
  List<String> _solvedIsoCodes = [];
  String? _errorMessage;

  GameViewModel({
    required CountryApiService countryApi,
    required GameStateRepository gameStateRepo,
  })  : _countryApi = countryApi,
        _gameStateRepo = gameStateRepo;

  GameStateData get state => _state;

  /// Non-null when initialization failed, so the UI can offer a retry.
  String? get errorMessage => _errorMessage;

  /// Whether the user may currently pick an option.
  bool get canAnswer => _state.state == GameState.ready && _state.currentQuestion != null;

  /// ISO codes of countries already solved (correct or attempts exhausted).
  List<String> get solvedIsoCodes => List.unmodifiable(_solvedIsoCodes);

  /// Number of countries still available to be asked.
  int get remainingCountries =>
      (_state.totalCountries - _solvedIsoCodes.length).clamp(0, _state.totalCountries);

  /// Loads persisted progress, fetches countries, then generates the first question.
  Future<void> initialize() async {
    _setState(_state.copyWith(state: GameState.loading));
    _errorMessage = null;

    try {
      // Restore persisted progress.
      final savedScore = await _gameStateRepo.getScore();
      final savedSolved = await _gameStateRepo.getSolvedIsoCodes();
      _solvedIsoCodes = List<String>.from(savedSolved);

      // Fetch the country pool.
      _allCountries = await _countryApi.fetchAllCountries();

      if (_allCountries.length < AppConstants.optionsPerQuestion) {
        _errorMessage =
            'Not enough countries available to build a question. Please try again later.';
        _setState(_state.copyWith(state: GameState.loading));
        notifyListeners();
        return;
      }

      _setState(
        _state.copyWith(
          score: savedScore,
          totalSolved: _solvedIsoCodes.length,
          totalCountries: _allCountries.length,
        ),
      );

      _generateQuestion();
    } catch (_) {
      _errorMessage = 'Failed to load countries. Check your connection and try again.';
      _setState(_state.copyWith(state: GameState.loading));
      notifyListeners();
    }
  }

  /// Retries initialization after an error.
  Future<void> retry() => initialize();

  /// Records the user's selection for the current question.
  ///
  /// A country is marked solved when the answer is correct *or* when all
  /// [AppConstants.maxAttempts] attempts are exhausted.
  Future<void> answer(String selectedIsoCode) async {
    if (!canAnswer) return;
    final question = _state.currentQuestion!;

    final isCorrect = selectedIsoCode == question.correctAnswer.isoCode;
    final newAttempts = _state.attempts + 1;
    final attemptsExhausted = newAttempts >= AppConstants.maxAttempts;
    final isSolved = isCorrect || attemptsExhausted;

    final pointsEarned = isCorrect ? ScoreCalculator.calculate(newAttempts) : 0;
    final newScore = _state.score + pointsEarned;

    if (isSolved && !_solvedIsoCodes.contains(question.correctAnswer.isoCode)) {
      _solvedIsoCodes = [..._solvedIsoCodes, question.correctAnswer.isoCode];
      await _gameStateRepo.saveSolvedIsoCodes(_solvedIsoCodes);
    }

    await _gameStateRepo.saveScore(newScore);

    _setState(
      _state.copyWith(
        state: GameState.answered,
        score: newScore,
        attempts: newAttempts,
        currentStreak: isCorrect ? _state.currentStreak + 1 : 0,
        totalSolved: _solvedIsoCodes.length,
        lastAnswerCorrect: isCorrect,
        lastPointsEarned: pointsEarned,
      ),
    );
  }

  /// Advances to the next question.
  ///
  /// If the previous question was not solved (wrong answer with attempts left),
  /// the same question is presented again.
  void nextQuestion() {
    if (_state.state != GameState.answered) return;

    final previous = _state.currentQuestion;
    final wasSolved = previous != null &&
        _solvedIsoCodes.contains(previous.correctAnswer.isoCode);

    if (!wasSolved) {
      // Retry the same flag with the attempt counter intact.
      _setState(
        _state.copyWith(
          state: GameState.ready,
          lastAnswerCorrect: null,
          lastPointsEarned: null,
        ),
      );
      return;
    }

    _generateQuestion();
  }

  /// Clears all progress and starts a fresh game.
  Future<void> resetGame() async {
    _solvedIsoCodes = [];
    await _gameStateRepo.clearAll();

    _errorMessage = null;
    _setState(
      GameStateData(
        state: GameState.ready,
        totalCountries: _allCountries.length,
      ),
    );

    _generateQuestion();
  }

  /// Picks an unsolved country and builds a 4-option question around it.
  void _generateQuestion() {
    final available =
        _allCountries.where((c) => !_solvedIsoCodes.contains(c.isoCode)).toList();

    if (available.isEmpty) {
      _setState(_state.copyWith(state: GameState.gameOver));
      return;
    }

    final correct = available[Random().nextInt(available.length)];
    final options = _generateOptions(correct, available);

    _setState(
      _state.copyWith(
        state: GameState.ready,
        currentQuestion: Question(correctAnswer: correct, options: options),
        attempts: 0,
        lastAnswerCorrect: null,
        lastPointsEarned: null,
      ),
    );
  }

  /// Builds exactly [AppConstants.optionsPerQuestion] shuffled options
  /// containing [correct].
  List<Country> _generateOptions(Country correct, List<Country> pool) {
    final options = <Country>[correct];

    for (final country in pool) {
      if (options.length >= AppConstants.optionsPerQuestion) break;
      if (country.isoCode == correct.isoCode) continue;
      options.add(country);
    }

    options.shuffle(Random());
    return options;
  }

  void _setState(GameStateData newState) {
    _state = newState;
    notifyListeners();
  }
}
