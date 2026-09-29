/// Represents the current state of the game.
enum GameState {
  /// Fetching countries from API
  loading,

  /// Question displayed, awaiting user answer
  ready,

  /// Answer selected, showing feedback
  answered,

  /// All countries have been solved
  gameOver,
}
