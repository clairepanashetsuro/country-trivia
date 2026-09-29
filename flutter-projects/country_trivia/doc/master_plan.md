# Country Trivia App — Master Plan

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Data Models](#data-models)
4. [API Layer](#api-layer)
5. [State Management (MVVM + Provider)](#state-management)
6. [Persistence Layer](#persistence-layer)
7. [UI/UX Design](#uiux-design)
8. [Project Structure](#project-structure)
9. [Execution Plan](#execution-plan)
10. [Testing Strategy](#testing-strategy)
11. [Error Handling](#error-handling)

---

## 1. Overview

A Flutter trivia game where users identify countries by their flags. The app presents a flag image and four country name options. Points are awarded based on attempt number, and progress persists across sessions.

### Core Features

| Feature | Description |
|---------|-------------|
| Flag Display | Show a country flag from flagcdn.com |
| 4-Option Quiz | Present 4 country names, one correct |
| Scoring System | 10 pts (1st try), 8 pts (2nd try), 5 pts (3rd try), 0 pts (failed) |
| Solved Tracking | Solved flags are excluded from future rounds |
| Game Reset | After all countries are solved, game resets |
| Persistence | Points and solved flags survive app restarts |

---

## 2. Architecture

### MVVM + Provider Pattern

```
┌─────────────────────────────────────────────────────────┐
│                        UI Layer                          │
│  ┌─────────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │  GamePage   │  │  ScoreBoard  │  │  ResultDialog │  │
│  └──────┬──────┘  └──────┬───────┘  └───────┬───────┘  │
│         │                │                   │           │
│         ▼                ▼                   ▼           │
│  ┌──────────────────────────────────────────────────┐   │
│  │              ViewModel Layer                      │   │
│  │  ┌────────────────────────────────────────────┐  │   │
│  │  │         GameViewModel                       │  │   │
│  │  │  - currentQuestion                          │  │   │
│  │  │  - score                                    │  │   │
│  │  │  - attempts                                 │  │   │
│  │  │  - gameState                                │  │   │
│  │  └────────────────────────────────────────────┘  │   │
│  └──────────────────────┬───────────────────────────┘   │
│                         │                               │
│                         ▼                               │
│  ┌──────────────────────────────────────────────────┐   │
│  │              Repository Layer                     │   │
│  │  ┌──────────────┐  ┌───────────────────────────┐ │   │
│  │  │ CountryRepo  │  │    GameStateRepository    │ │   │
│  │  └──────┬───────┘  └────────────┬──────────────┘ │   │
│  └─────────┼───────────────────────┼─────────────────┘   │
│            │                       │                      │
│            ▼                       ▼                      │
│  ┌──────────────┐      ┌───────────────────────────┐    │
│  │  API Layer   │      │    Local Storage          │    │
│  │  (Dio/HTTP)  │      │    (SharedPreferences)     │    │
│  └──────────────┘      └───────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Responsibility |
|-------|---------------|
| **UI** | Render widgets, capture user input, display state |
| **ViewModel** | Hold game state, expose commands, notify listeners |
| **Repository** | Abstract data sources, combine API + local data |
| **API** | Fetch country data from REST API |
| **Local Storage** | Persist score and solved flags |

---

## 3. Data Models

### Country Model

```dart
class Country {
  final String name;        // Common name (e.g., "Germany")
  final String isoCode;     // ISO 3166-1 alpha-2 (e.g., "de")
  final String flagUrl;     // Constructed: https://flagcdn.com/w320/{iso}.png

  const Country({
    required this.name,
    required this.isoCode,
  }) : flagUrl = 'https://flagcdn.com/w320/${isoCode.toLowerCase()}.png';

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] as String,
      isoCode: json['cca2'] as String,
    );
  }
}
```

### Question Model

```dart
class Question {
  final Country correctAnswer;
  final List<Country> options;  // Always 4 options, shuffled

  const Question({
    required this.correctAnswer,
    required this.options,
  });
}
```

### Game State Enum

```dart
enum GameState {
  loading,      // Fetching countries
  ready,        // Question displayed, awaiting answer
  answered,     // Answer selected, showing feedback
  gameOver,     // All countries solved
}
```

### Game State Model

```dart
class GameStateData {
  final GameState state;
  final Question? currentQuestion;
  final int score;
  final int attempts;        // 0-3 for current question
  final int currentStreak;
  final int totalSolved;
  final int totalCountries;
  final bool? lastAnswerCorrect;
  final int? lastPointsEarned;

  const GameStateData({
    this.state = GameState.loading,
    this.currentQuestion,
    this.score = 0,
    this.attempts = 0,
    this.currentStreak = 0,
    this.totalSolved = 0,
    this.totalCountries = 0,
    this.lastAnswerCorrect,
    this.lastPointsEarned,
  });

  GameStateData copyWith({...}) => GameStateData(...);
}
```

---

## 4. API Layer

### Countries API

**Endpoint:** `https://restcountries.com/v3.1/all?fields=name,cca2`

**Response Format:**
```json
[
  {
    "name": { "common": "Germany", "official": "Federal Republic of Germany" },
    "cca2": "DE"
  }
]
```

### API Service

```dart
abstract class CountryApiService {
  Future<List<Country>> fetchAllCountries();
}

class CountryApiServiceImpl implements CountryApiService {
  final Dio _dio;

  CountryApiServiceImpl(this._dio);

  @override
  Future<List<Country>> fetchAllCountries() async {
    final response = await _dio.get(
      'https://restcountries.com/v3.1/all',
      queryParameters: {'fields': 'name,cca2'},
    );
    return (response.data as List)
        .map((json) => Country.fromJson(json))
        .where((c) => c.isoCode.isNotEmpty && c.name.isNotEmpty)
        .toList();
  }
}
```

### Flag CDN

Flags are loaded directly via URL pattern: `https://flagcdn.com/w320/{iso}.png`

- **w320** = 320px width (good balance of quality and load time)
- Cached automatically by Flutter's `Image.network` / `CachedNetworkImage`

---

## 5. State Management

### Provider Setup

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<Dio>(create: (_) => Dio()),
        Provider<CountryApiService>(
          create: (ctx) => CountryApiServiceImpl(ctx.read<Dio>()),
        ),
        Provider<GameStateRepository>(
          create: (_) => GameStateRepositoryImpl(),
        ),
        ChangeNotifierProvider<GameViewModel>(
          create: (ctx) => GameViewModel(
            countryApi: ctx.read<CountryApiService>(),
            gameStateRepo: ctx.read<GameStateRepository>(),
          ),
        ),
      ],
      child: const CountryTriviaApp(),
    ),
  );
}
```

### GameViewModel

```dart
class GameViewModel extends ChangeNotifier {
  final CountryApiService _countryApi;
  final GameStateRepository _gameStateRepo;

  GameStateData _state = const GameStateData();
  List<Country> _allCountries = [];
  List<Country> _solvedCountries = [];

  GameStateData get state => _state;

  GameViewModel({
    required CountryApiService countryApi,
    required GameStateRepository gameStateRepo,
  }) : _countryApi = countryApi,
       _gameStateRepo = gameStateRepo;

  /// Initialize: load saved state and fetch countries
  Future<void> initialize() async {
    _setState(_state.copyWith(state: GameState.loading));
    
    // Load persisted data
    final savedScore = await _gameStateRepo.getScore();
    final savedSolved = await _gameStateRepo.getSolvedIsoCodes();
    
    _solvedCountries = savedSolved;
    
    // Fetch countries from API
    _allCountries = await _countryApi.fetchAllCountries();
    
    _setState(_state.copyWith(
      state: GameState.ready,
      score: savedScore,
      totalSolved: savedSolved.length,
      totalCountries: _allCountries.length,
    ));
    
    _generateQuestion();
  }

  /// Generate a new question excluding solved countries
  void _generateQuestion() {
    final available = _allCountries
        .where((c) => !_solvedCountries.contains(c.isoCode))
        .toList();
    
    if (available.isEmpty) {
      _setState(_state.copyWith(state: GameState.gameOver));
      return;
    }
    
    final correct = available[Random().nextInt(available.length)];
    final options = _generateOptions(correct, available);
    
    _setState(_state.copyWith(
      state: GameState.ready,
      currentQuestion: Question(correctAnswer: correct, options: options),
      attempts: 0,
      lastAnswerCorrect: null,
      lastPointsEarned: null,
    ));
  }

  /// Generate 4 options including the correct answer
  List<Country> _generateOptions(Country correct, List<Country> pool) {
    final shuffled = List<Country>.from(pool)..shuffle();
    final options = <Country>[correct];
    
    for (final country in shuffled) {
      if (country.isoCode != correct.isoCode && options.length < 4) {
        options.add(country);
      }
    }
    
    options.shuffle();
    return options;
  }

  /// Handle user answer
  Future<void> answer(String selectedIsoCode) async {
    if (_state.state != GameState.ready || _state.currentQuestion == null) return;
    
    final isCorrect = selectedIsoCode == _state.currentQuestion!.correctAnswer.isoCode;
    final newAttempts = _state.attempts + 1;
    int pointsEarned = 0;
    
    if (isCorrect) {
      pointsEarned = _calculatePoints(newAttempts);
    } else if (newAttempts >= 3) {
      // No points, reveal correct answer
    }
    
    final newScore = _state.score + pointsEarned;
    final newSolved = isCorrect || newAttempts >= 3
        ? [..._solvedCountries, _state.currentQuestion!.correctAnswer.isoCode]
        : _solvedCountries;
    
    _solvedCountries = newSolved;
    
    // Persist
    await _gameStateRepo.saveScore(newScore);
    await _gameStateRepo.saveSolvedIsoCodes(newSolved);
    
    _setState(_state.copyWith(
      state: GameState.answered,
      score: newScore,
      attempts: newAttempts,
      totalSolved: newSolved.length,
      lastAnswerCorrect: isCorrect,
      lastPointsEarned: pointsEarned,
    ));
  }

  /// Calculate points based on attempt number
  int _calculatePoints(int attempt) {
    switch (attempt) {
      case 1: return 10;
      case 2: return 8;
      case 3: return 5;
      default: return 0;
    }
  }

  /// Move to next question
  void nextQuestion() {
    _generateQuestion();
  }

  /// Reset the entire game
  Future<void> resetGame() async {
    _solvedCountries = [];
    await _gameStateRepo.saveScore(0);
    await _gameStateRepo.saveSolvedIsoCodes([]);
    
    _setState(GameStateData(
      state: GameState.ready,
      totalCountries: _allCountries.length,
    ));
    
    _generateQuestion();
  }

  void _setState(GameStateData newState) {
    _state = newState;
    notifyListeners();
  }
}
```

---

## 6. Persistence Layer

### Storage Keys

| Key | Type | Description |
|-----|------|-------------|
| `game_score` | int | Current total score |
| `solved_countries` | List<String> | ISO codes of solved countries |

### Repository Interface

```dart
abstract class GameStateRepository {
  Future<int> getScore();
  Future<void> saveScore(int score);
  Future<List<String>> getSolvedIsoCodes();
  Future<void> saveSolvedIsoCodes(List<String> isoCodes);
  Future<void> clearAll();
}
```

### Implementation (SharedPreferences)

```dart
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
```

---

## 7. UI/UX Design

### Screen Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Splash     │────▶│  Game Page  │────▶│  Game Over  │
│  Screen     │     │  (Main)     │     │  Dialog     │
└─────────────┘     └──────┬──────┘     └─────────────┘
                          │
                          ▼
                   ┌─────────────┐
                   │  Result     │
                   │  Feedback   │
                   │  (Overlay)  │
                   └─────────────┘
```

### Game Page Layout

```
┌─────────────────────────────────────┐
│  🏆 Score: 125    Solved: 45/195   │  ← Header Bar
├─────────────────────────────────────┤
│                                     │
│         ┌─────────────────┐         │
│         │                 │         │
│         │    FLAG IMAGE   │         │  ← Flag (w320)
│         │   (320px wide)  │         │
│         │                 │         │
│         └─────────────────┘         │
│                                     │
│     Which country is this?          │  ← Question Text
│                                     │
│  ┌─────────────────────────────┐    │
│  │  ○ Option A                 │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │  ● Option B (Selected)      │    │  ← Options
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │  ○ Option C                 │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │  ○ Option D                 │    │
│  └─────────────────────────────┘    │
│                                     │
│  Attempt 2/3 ───────────────────    │  ← Progress Indicator
│                                     │
└─────────────────────────────────────┘
```

### Answer Feedback States

| State | Visual Feedback |
|-------|----------------|
| Correct (1st try) | Green highlight, "+10 points" animation |
| Correct (2nd try) | Green highlight, "+8 points" animation |
| Correct (3rd try) | Green highlight, "+5 points" animation |
| Wrong (1st/2nd) | Red highlight, shake animation, try again |
| Wrong (3rd) | Red highlight, correct answer revealed in green |

### Color Scheme

| Element | Color |
|---------|-------|
| Primary | `#1E88E5` (Blue) |
| Correct | `#43A047` (Green) |
| Wrong | `#E53935` (Red) |
| Background | `#F5F5F5` (Light Gray) |
| Card | `#FFFFFF` (White) |

---

## 8. Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   └── api_constants.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── score_calculator.dart
├── data/
│   ├── models/
│   │   ├── country.dart
│   │   ├── question.dart
│   │   └── game_state_data.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   └── game_state_repository.dart
│   └── enums/
│       └── game_state.dart
├── viewmodels/
│   └── game_viewmodel.dart
└── views/
    ├── game_page.dart
    ├── widgets/
    │   ├── flag_display.dart
    │   ├── answer_option.dart
    │   ├── score_header.dart
    │   ├── feedback_overlay.dart
    │   └── game_over_dialog.dart
    └── splash_page.dart
```

---

## 9. Execution Plan

### Phase 1: Project Setup (Day 1)

| Task | Description |
|------|-------------|
| 1.1 | `flutter create country_trivia` |
| 1.2 | Add dependencies: `provider`, `dio`, `shared_preferences` |
| 1.3 | Set up project structure (folders) |
| 1.4 | Configure `pubspec.yaml` with assets |

### Phase 2: Data Layer (Day 1-2)

| Task | Description |
|------|-------------|
| 2.1 | Create `Country` model with JSON parsing |
| 2.2 | Create `Question` model |
| 2.3 | Create `GameState` enum and `GameStateData` class |
| 2.4 | Implement `CountryApiService` with Dio |
| 2.5 | Implement `GameStateRepository` with SharedPreferences |

### Phase 3: ViewModel (Day 2)

| Task | Description |
|------|-------------|
| 3.1 | Create `GameViewModel` with ChangeNotifier |
| 3.2 | Implement `initialize()` - load saved state + fetch countries |
| 3.3 | Implement `_generateQuestion()` - create 4-option questions |
| 3.4 | Implement `answer()` - handle scoring logic |
| 3.5 | Implement `nextQuestion()` and `resetGame()` |

### Phase 4: UI Layer (Day 2-3)

| Task | Description |
|------|-------------|
| 4.1 | Create `GamePage` scaffold with Provider |
| 4.2 | Build `ScoreHeader` widget |
| 4.3 | Build `FlagDisplay` widget with CachedNetworkImage |
| 4.4 | Build `AnswerOption` widget with selection states |
| 4.5 | Build `FeedbackOverlay` for correct/wrong animations |
| 4.6 | Build `GameOverDialog` with reset option |
| 4.7 | Add loading and error states |

### Phase 5: Polish (Day 3)

| Task | Description |
|------|-------------|
| 5.1 | Add animations (fade, slide, shake) |
| 5.2 | Add haptic feedback on answers |
| 5.3 | Add sound effects (optional) |
| 5.4 | Dark mode support |
| 5.5 | Responsive layout for tablets |

### Phase 6: Testing (Day 3-4)

| Task | Description |
|------|-------------|
| 6.1 | Unit test `GameViewModel` logic |
| 6.2 | Unit test `ScoreCalculator` |
| 6.3 | Widget test `GamePage` |
| 6.4 | Integration test full game flow |

---

## 10. Testing Strategy

### Unit Tests

```dart
// test/score_calculator_test.dart
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
    test('returns 0 points for failed attempt', () {
      expect(ScoreCalculator.calculate(4), 0);
    });
  });
}
```

### ViewModel Tests

```dart
// test/game_viewmodel_test.dart
void main() {
  group('GameViewModel', () {
    test('initializes with saved score', () async { ... });
    test('generates question with 4 options', () async { ... });
    test('awards correct points on first attempt', () async { ... });
    test('reveals answer after 3 failed attempts', () async { ... });
    test('excludes solved countries from questions', () async { ... });
    test('resets game correctly', () async { ... });
  });
}
```

---

## 11. Error Handling

### Network Errors

| Scenario | Handling |
|----------|----------|
| No internet on launch | Show cached data if available, else error screen with retry |
| API timeout | Show snackbar with retry button |
| Invalid response | Log error, show generic error message |

### Edge Cases

| Scenario | Handling |
|----------|----------|
| All countries solved | Show game over dialog with reset option |
| Fewer than 4 countries available | Disable game, show message |
| Duplicate country names | Append ISO code in parentheses |
| Flag image fails to load | Show placeholder with country code |

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  dio: ^5.4.0
  shared_preferences: ^2.2.2
  cached_network_image: ^3.3.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.2
  build_runner: ^2.4.7
```

---

## API Reference

### Countries API

- **URL:** `https://restcountries.com/v3.1/all?fields=name,cca2`
- **Method:** GET
- **Response:** Array of country objects with `name.common` and `cca2`

### Flag CDN

- **URL Pattern:** `https://flagcdn.com/w320/{iso}.png`
- **Sizes Available:** w80, w160, w320, w640, w1280, w2560
- **Format:** PNG

---

*Plan created: 2026-09-29*
