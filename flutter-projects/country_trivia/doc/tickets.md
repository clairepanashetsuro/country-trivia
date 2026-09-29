# Country Trivia App — Execution Tickets

## Dependency Graph

### Visual Dependency Map

```
                              ┌─────────────────────────────────────────────────────────────────────────────────────┐
                              │                              PHASE 1: SETUP                                      │
                              │                                                                                     │
                              │    ┌──────────┐                                                                         │
                              │    │   T001   │ Initialize Flutter Project                                            │
                              │    │ 30 min   │                                                                         │
                              │    └────┬─────┘                                                                         │
                              │         │                                                                               │
                              │         ▼                                                                               │
                              │    ┌──────────┐                                                                         │
                              │    │   T002   │ Add Dependencies                                                        │
                              │    │ 15 min   │                                                                         │
                              │    └────┬─────┘                                                                         │
                              └─────────┼───────────────────────────────────────────────────────────────────────────────┘
                                        │
                    ┌───────────────────┼───────────────────┐
                    │                   │                   │
                    ▼                   ▼                   ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              PHASE 2: DATA LAYER                                                                     │
│                                                                                                                      │
│    ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐    │
│    │                        GROUP A: Data Models (Concurrent)                                                      │    │
│    │                                                                                                              │    │
│    │    ┌──────────┐          ┌──────────┐          ┌──────────┐                                                    │    │
│    │    │   T003   │          │   T004   │          │   T005   │                                                    │    │
│    │    │ Country  │          │ Question │          │  Game    │                                                    │    │
│    │    │  Model   │          │  Model   │          │  State   │                                                    │    │
│    │    │ 30 min   │          │ 20 min   │          │ 30 min   │                                                    │    │
│    │    └────┬─────┘          └────┬─────┘          └────┬─────┘                                                    │    │
│    │         │                     │                     │                                                          │    │
│    └─────────┼─────────────────────┼─────────────────────┼──────────────────────────────────────────────────────────┘    │
│              │                     │                     │                                                             │
│              │    ┌────────────────┘                     │                                                             │
│              │    │                                      │                                                             │
│              ▼    ▼                                      ▼                                                             │
│    ┌─────────────────────────┐              ┌─────────────────────────┐                                               │
│    │      GROUP B: Services  │              │   GROUP C: Constants    │                                               │
│    │       (Concurrent)      │              │      (Concurrent)       │                                               │
│    │                         │              │                         │                                               │
│    │  ┌──────────┐ ┌──────────┐            │  ┌──────────┐ ┌──────────┐                                               │
│    │  │   T006   │ │   T007   │            │  │   T008   │ │   T009   │                                               │
│    │  │   API    │ │  Game    │            │  │   API    │ │  Score   │                                               │
│    │  │ Service  │ │  State   │            │  │ Constants│ │Calculator│                                               │
│    │  │ 45 min   │ │  Repo    │            │  │ 10 min   │ │ 15 min   │                                               │
│    │  │          │ │ 45 min   │            │  │          │ │          │                                               │
│    │  └────┬─────┘ └────┬─────┘            │  └────┬─────┘ └────┬─────┘                                               │
│    │       │            │                  │       │            │                                                      │
│    └───────┼────────────┼──────────────────┴───────┼────────────┼──────────────────────────────────────────────────────┘
│            │            │                          │            │
│            │            │                          │            │
│            ▼            ▼                          ▼            ▼
│    ┌─────────────────────────┐              ┌─────────────────────────┐                                               │
│    │      GROUP D: Theme     │              │                         │                                               │
│    │       (Concurrent)      │              │                         │                                               │
│    │                         │              │                         │                                               │
│    │  ┌──────────┐ ┌──────────┐            │                         │                                               │
│    │  │   T010   │ │   T011   │            │                         │                                               │
│    │  │   App    │ │   App    │            │                         │                                               │
│    │  │  Theme   │ │Constants │            │                         │                                               │
│    │  │ 30 min   │ │ 10 min   │            │                         │                                               │
│    │  └────┬─────┘ └────┬─────┘            │                         │                                               │
│    │       │            │                  │                         │                                               │
│    └───────┼────────────┼──────────────────┴─────────────────────────┘                                               │
│            │            │                                                                                            │
│            └─────┬──────┘                                                                                            │
│                  │                                                                                                   │
│                  ▼                                                                                                   │
│           ┌──────────┐                                                                                               │
│           │   T012   │ Provider Setup                                                                                │
│           │ 20 min   │                                                                                               │
│           └────┬─────┘                                                                                               │
└────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              PHASE 3: VIEWMODEL                                                                       │
│                                                                                                                      │
│           ┌──────────┐                                                                                               │
│           │   T013   │ GameViewModel                                                                                 │
│           │ 2 hours  │                                                                                               │
│           └────┬─────┘                                                                                               │
└────────────────┼─────────────────────────────────────────────────────────────────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              PHASE 4: UI LAYER                                                                        │
│                                                                                                                      │
│           ┌──────────┐                                                                                               │
│           │   T014   │ Game Page Scaffold                                                                            │
│           │ 45 min   │                                                                                               │
│           └────┬─────┘                                                                                               │
│                │                                                                                                     │
│       ┌────────┼────────┐                                                                                            │
│       │        │        │                                                                                            │
│       ▼        ▼        ▼                                                                                            │
│    ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐    │
│    │                     GROUP E: UI Widgets (Concurrent)                                                          │    │
│    │                                                                                                              │    │
│    │  ┌──────────┐    ┌──────────┐    ┌──────────┐                                                                 │    │
│    │  │   T015   │    │   T016   │    │   T017   │                                                                 │    │
│    │  │  Score   │    │   Flag   │    │  Answer  │                                                                 │    │
│    │  │  Header  │    │ Display  │    │  Option  │                                                                 │    │
│    │  │ 30 min   │    │ 30 min   │    │ 45 min   │                                                                 │    │
│    │  └────┬─────┘    └────┬─────┘    └────┬─────┘                                                                 │    │
│    │       │               │               │                                                                        │    │
│    └───────┼───────────────┼───────────────┼────────────────────────────────────────────────────────────────────────┘    │
│            │               │               │                                                                         │
│            └───────┬───────┘               │                                                                         │
│                    │                       │                                                                         │
│           ┌────────┴────────┐     ┌────────┴────────┐                                                                │
│           │                 │     │                 │                                                                │
│           ▼                 ▼     ▼                 ▼                                                                │
│    ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐    │
│    │                  GROUP F: Overlays & Dialogs (Concurrent)                                                     │    │
│    │                                                                                                              │    │
│    │  ┌──────────────────────┐    ┌──────────────────────┐                                                         │    │
│    │  │        T018          │    │        T019          │                                                         │    │
│    │  │   Feedback Overlay   │    │   Game Over Dialog   │                                                         │    │
│    │  │      45 min          │    │      30 min          │                                                         │    │
│    │  └──────────┬───────────┘    └──────────┬───────────┘                                                         │    │
│    │             │                           │                                                                      │    │
│    └─────────────┼───────────────────────────┼──────────────────────────────────────────────────────────────────────┘    │
│                  │                           │                                                                       │
│                  └───────────┬───────────────┘                                                                       │
│                              │                                                                                       │
│                              ▼                                                                                       │
│                       ┌──────────┐                                                                                   │
│                       │   T020   │ Splash Screen                                                                     │
│                       │ 20 min   │                                                                                   │
│                       └────┬─────┘                                                                                   │
└────────────────────────────┼────────────────────────────────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              PHASE 5: POLISH                                                                         │
│                                                                                                                      │
│                       ┌──────────┐                                                                                   │
│                       │   T021   │ Animations & Haptics                                                              │
│                       │  1 hour  │                                                                                   │
│                       └────┬─────┘                                                                                   │
└────────────────────────────┼────────────────────────────────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                              PHASE 6: TESTING                                                                        │
│                                                                                                                      │
│                       ┌──────────┐                                                                                   │
│                       │   T022   │ Integration Testing                                                               │
│                       │ 2 hours  │                                                                                   │
│                       └──────────┘                                                                                   │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

### Dependency Matrix

| Ticket | Depends On | Concurrent With | Phase |
|--------|------------|-----------------|-------|
| **T001** | — | — | 1 |
| **T002** | T001 | — | 1 |
| **T003** | T002 | T004, T005 | 2 |
| **T004** | T002 | T003, T005 | 2 |
| **T005** | T002 | T003, T004 | 2 |
| **T006** | T003 | T007 | 2 |
| **T007** | T005 | T006 | 2 |
| **T008** | T006 | T009 | 2 |
| **T009** | T005 | T008 | 2 |
| **T010** | T008 | T011 | 2 |
| **T011** | T009 | T010 | 2 |
| **T012** | T010, T011 | — | 2 |
| **T013** | T012 | — | 3 |
| **T014** | T013 | — | 4 |
| **T015** | T014 | T016, T017 | 4 |
| **T016** | T014 | T015, T017 | 4 |
| **T017** | T014 | T015, T016 | 4 |
| **T018** | T015, T016, T017 | T019 | 4 |
| **T019** | T015, T016, T017 | T018 | 4 |
| **T020** | T018, T019 | — | 4 |
| **T021** | T020 | — | 5 |
| **T022** | T021 | — | 6 |

### Critical Path

The critical path (longest chain of dependencies) determines minimum project duration:

```
T001 → T002 → T003 → T006 → T008 → T010 → T012 → T013 → T014 → T017 → T018 → T020 → T021 → T022
```

**Critical Path Duration:** ~10.5 hours

### Concurrency Opportunities

```
                    ┌─────────────────────────────────────────────────────────┐
                    │                                                         │
                    │   T003 ──┐                                            │
                    │   T004 ──┼── All three start after T002               │
                    │   T005 ──┘                                            │
                    │                                                         │
                    │   T006 ──┐                                            │
                    │   T007 ──┘── Both start after Group A completes           │
                    │                                                         │
                    │   T008 ──┐                                            │
                    │   T009 ──┘── Both start after Group B completes           │
                    │                                                         │
                    │   T010 ──┐                                            │
                    │   T011 ──┘── Both start after Group C completes           │
                    │                                                         │
                    │   T015 ──┐                                            │
                    │   T016 ──┼── All three start after T014                  │
                    │   T017 ──┘                                            │
                    │                                                         │
                    │   T018 ──┐                                            │
                    │   T019 ──┘── Both start after Group E completes           │
                    │                                                         │
                    └─────────────────────────────────────────────────────────┘
```

### Gantt Chart (Optimized Schedule)

```
Week 1:
Day 1:  [T001][T002][T003+T004+T005][T006+T007][T008+T009][T010+T011][T012]
Day 2:  [T013..............][T014][T015+T016+T017][T018+T019][T020][T021][T022..]

Legend:
[XXX] = Sequential ticket
[XXX+YYY] = Concurrent tickets
[.......] = Multi-hour ticket spanning time
```

**Legend:**
- `──▶` = must complete before next ticket starts
- `┬──▶` = concurrent tickets (can be executed in parallel)
- `│` = vertical dependency flow
- `[XXX+YYY]` = tickets that can run in parallel

---

## Phase 1: Project Setup

### T001 — Initialize Flutter Project
| Field | Value |
|-------|-------|
| **ID** | T001 |
| **Phase** | 1 |
| **Depends On** | None |
| **Concurrent With** | None |
| **Estimated Effort** | 30 min |

**Description:**
Create the Flutter project and configure the base structure.

**Acceptance Criteria:**
- [ ] `flutter create country_trivia` completes successfully
- [ ] Project builds and runs on emulator/device
- [ ] `.gitignore` is properly configured
- [ ] Project structure folders created: `core/`, `data/`, `viewmodels/`, `views/`

**Files:**
- `pubspec.yaml`
- `lib/main.dart`
- `lib/app.dart`

---

### T002 — Add Dependencies
| Field | Value |
|-------|-------|
| **ID** | T002 |
| **Phase** | 1 |
| **Depends On** | T001 |
| **Concurrent With** | None |
| **Estimated Effort** | 15 min |

**Description:**
Add all required dependencies to `pubspec.yaml` and run `flutter pub get`.

**Acceptance Criteria:**
- [ ] `provider: ^6.1.1` added
- [ ] `dio: ^5.4.0` added
- [ ] `shared_preferences: ^2.2.2` added
- [ ] `cached_network_image: ^3.3.1` added
- [ ] `mockito: ^5.4.2` and `build_runner: ^2.4.7` in dev_dependencies
- [ ] `flutter pub get` completes without errors

**Files:**
- `pubspec.yaml`

---

## Phase 2: Data Layer

### T003 — Create Country Model
| Field | Value |
|-------|-------|
| **ID** | T003 |
| **Phase** | 2 |
| **Depends On** | T002 |
| **Concurrent With** | T004, T005 |
| **Estimated Effort** | 30 min |

**Description:**
Create the `Country` data model with JSON parsing and flag URL construction.

**Acceptance Criteria:**
- [ ] `Country` class with `name`, `isoCode`, `flagUrl` fields
- [ ] `Country.fromJson()` factory constructor parses `name.common` and `cca2`
- [ ] `flagUrl` getter returns `https://flagcdn.com/w320/{iso}.png`
- [ ] Unit test verifies JSON parsing with sample API response

**Files:**
- `lib/data/models/country.dart`
- `test/data/models/country_test.dart`

---

### T004 — Create Question Model
| Field | Value |
|-------|-------|
| **ID** | T004 |
| **Phase** | 2 |
| **Depends On** | T002 |
| **Concurrent With** | T003, T005 |
| **Estimated Effort** | 20 min |

**Description:**
Create the `Question` model representing a single quiz question.

**Acceptance Criteria:**
- [ ] `Question` class with `correctAnswer` (Country) and `options` (List<Country>)
- [ ] `options` always contains exactly 4 items
- [ ] `options` includes the correct answer
- [ ] Unit test verifies question structure

**Files:**
- `lib/data/models/question.dart`
- `test/data/models/question_test.dart`

---

### T005 — Create Game State Models
| Field | Value |
|-------|-------|
| **ID** | T005 |
| **Phase** | 2 |
| **Depends On** | T002 |
| **Concurrent With** | T003, T004 |
| **Estimated Effort** | 30 min |

**Description:**
Create the `GameState` enum and `GameStateData` immutable state class.

**Acceptance Criteria:**
- [ ] `GameState` enum with values: `loading`, `ready`, `answered`, `gameOver`
- [ ] `GameStateData` class with all fields: `state`, `currentQuestion`, `score`, `attempts`, `currentStreak`, `totalSolved`, `totalCountries`, `lastAnswerCorrect`, `lastPointsEarned`
- [ ] `copyWith()` method implemented
- [ ] Unit test verifies `copyWith` behavior

**Files:**
- `lib/data/enums/game_state.dart`
- `lib/data/models/game_state_data.dart`
- `test/data/models/game_state_data_test.dart`

---

### T006 — Implement API Service
| Field | Value |
|-------|-------|
| **ID** | T006 |
| **Phase** | 2 |
| **Depends On** | T003 |
| **Concurrent With** | T007 |
| **Estimated Effort** | 45 min |

**Description:**
Create the `CountryApiService` abstract class and implementation using Dio.

**Acceptance Criteria:**
- [ ] `CountryApiService` abstract class with `fetchAllCountries()` method
- [ ] `CountryApiServiceImpl` with Dio injection
- [ ] API call to `https://restcountries.com/v3.1/all?fields=name,cca2`
- [ ] Response parsing filters out entries with empty `isoCode` or `name`
- [ ] Unit test with mocked Dio response

**Files:**
- `lib/data/services/api_service.dart`
- `test/data/services/api_service_test.dart`

---

### T007 — Implement Game State Repository
| Field | Value |
|-------|-------|
| **ID** | T007 |
| **Phase** | 2 |
| **Depends On** | T005 |
| **Concurrent With** | T006 |
| **Estimated Effort** | 45 min |

**Description:**
Create the `GameStateRepository` for persisting score and solved countries.

**Acceptance Criteria:**
- [ ] `GameStateRepository` abstract class with methods: `getScore()`, `saveScore()`, `getSolvedIsoCodes()`, `saveSolvedIsoCodes()`, `clearAll()`
- [ ] `GameStateRepositoryImpl` using SharedPreferences
- [ ] Storage keys: `game_score` (int), `solved_countries` (List<String>)
- [ ] Unit tests with mocked SharedPreferences

**Files:**
- `lib/data/services/game_state_repository.dart`
- `test/data/services/game_state_repository_test.dart`

---

### T008 — Create API Constants
| Field | Value |
|-------|-------|
| **ID** | T008 |
| **Phase** | 2 |
| **Depends On** | T006 |
| **Concurrent With** | T009 |
| **Estimated Effort** | 10 min |

**Description:**
Create constants file for API endpoints and configuration.

**Acceptance Criteria:**
- [ ] `ApiConstants` class with `countriesUrl` and `flagUrlTemplate`
- [ ] Flag width constant (320)
- [ ] Timeout configuration

**Files:**
- `lib/core/constants/api_constants.dart`

---

### T009 — Create Score Calculator Utility
| Field | Value |
|-------|-------|
| **ID** | T009 |
| **Phase** | 2 |
| **Depends On** | T005 |
| **Concurrent With** | T008 |
| **Estimated Effort** | 15 min |

**Description:**
Create utility class for calculating points based on attempt number.

**Acceptance Criteria:**
- [ ] `ScoreCalculator.calculate(int attempt)` returns 10, 8, 5, or 0
- [ ] Returns 0 for attempt > 3
- [ ] Unit tests for all attempt values

**Files:**
- `lib/core/utils/score_calculator.dart`
- `test/core/utils/score_calculator_test.dart`

---

### T010 — Create App Theme
| Field | Value |
|-------|-------|
| **ID** | T010 |
| **Phase** | 2 |
| **Depends On** | T008 |
| **Concurrent With** | T011 |
| **Estimated Effort** | 30 min |

**Description:**
Create app theme configuration with colors, typography, and styling.

**Acceptance Criteria:**
- [ ] `AppTheme` class with `ThemeData` configuration
- [ ] Primary color: `#1E88E5`
- [ ] Correct color: `#43A047`
- [ ] Wrong color: `#E53935`
- [ ] Background color: `#F5F5F5`
- [ ] Dark mode support

**Files:**
- `lib/core/theme/app_theme.dart`

---

### T011 — Create App Constants
| Field | Value |
|-------|-------|
| **ID** | T011 |
| **Phase** | 2 |
| **Depends On** | T009 |
| **Concurrent With** | T010 |
| **Estimated Effort** | 10 min |

**Description:**
Create general app constants (storage keys, animation durations, etc.).

**Acceptance Criteria:**
- [ ] Storage key constants
- [ ] Animation duration constants
- [ ] Scoring constants (10, 8, 5, 0)
- [ ] Maximum attempts constant (3)

**Files:**
- `lib/core/constants/app_constants.dart`

---

### T012 — Create Provider Setup
| Field | Value |
|-------|-------|
| **ID** | T012 |
| **Phase** | 2 |
| **Depends On** | T010, T011 |
| **Concurrent With** | None |
| **Estimated Effort** | 20 min |

**Description:**
Configure MultiProvider in `main.dart` with all dependencies.

**Acceptance Criteria:**
- [ ] `MultiProvider` with `Dio`, `CountryApiService`, `GameStateRepository`, `GameViewModel`
- [ ] Proper dependency injection chain
- [ ] App launches without provider errors

**Files:**
- `lib/main.dart`
- `lib/app.dart`

---

## Phase 3: ViewModel

### T013 — Implement GameViewModel
| Field | Value |
|-------|-------|
| **ID** | T013 |
| **Phase** | 3 |
| **Depends On** | T012 |
| **Concurrent With** | None |
| **Estimated Effort** | 2 hours |

**Description:**
Create the `GameViewModel` with all game logic.

**Acceptance Criteria:**
- [ ] `GameViewModel` extends `ChangeNotifier`
- [ ] `initialize()` loads saved state and fetches countries
- [ ] `_generateQuestion()` creates 4-option questions excluding solved countries
- [ ] `answer()` handles scoring logic (10/8/5/0 points)
- [ ] `nextQuestion()` generates next question
- [ ] `resetGame()` clears all progress
- [ ] Solved countries excluded from future questions
- [ ] Game over triggered when all countries solved
- [ ] All state changes call `notifyListeners()`
- [ ] Unit tests for all methods

**Files:**
- `lib/viewmodels/game_viewmodel.dart`
- `test/viewmodels/game_viewmodel_test.dart`

---

## Phase 4: UI Layer

### T014 — Create Game Page Scaffold
| Field | Value |
|-------|-------|
| **ID** | T014 |
| **Phase** | 4 |
| **Depends On** | T013 |
| **Concurrent With** | None |
| **Estimated Effort** | 45 min |

**Description:**
Create the main `GamePage` widget with Provider integration.

**Acceptance Criteria:**
- [ ] `GamePage` consumes `GameViewModel` via `context.watch`
- [ ] Layout: header, flag area, question text, options list, progress indicator
- [ ] Loading state shows `CircularProgressIndicator`
- [ ] Error state shows retry button
- [ ] Responsive layout for different screen sizes

**Files:**
- `lib/views/game_page.dart`

---

### T015 — Create Score Header Widget
| Field | Value |
|-------|-------|
| **ID** | T015 |
| **Phase** | 4 |
| **Depends On** | T014 |
| **Concurrent With** | T016, T017 |
| **Estimated Effort** | 30 min |

**Description:**
Create the header widget displaying score and progress.

**Acceptance Criteria:**
- [ ] Displays current score with trophy icon
- [ ] Displays solved count (e.g., "45/195")
- [ ] Styled with primary color theme
- [ ] Animates on score change

**Files:**
- `lib/views/widgets/score_header.dart`

---

### T016 — Create Flag Display Widget
| Field | Value |
|-------|-------|
| **ID** | T016 |
| **Phase** | 4 |
| **Depends On** | T014 |
| **Concurrent With** | T015, T017 |
| **Estimated Effort** | 30 min |

**Description:**
Create the flag image display widget.

**Acceptance Criteria:**
- [ ] Uses `CachedNetworkImage` for flag loading
- [ ] Shows placeholder while loading
- [ ] Shows error widget if image fails
- [ ] 320px width, centered
- [ ] Rounded corners and shadow

**Files:**
- `lib/views/widgets/flag_display.dart`

---

### T017 — Create Answer Option Widget
| Field | Value |
|-------|-------|
| **ID** | T017 |
| **Phase** | 4 |
| **Depends On** | T014 |
| **Concurrent With** | T015, T016 |
| **Estimated Effort** | 45 min |

**Description:**
Create the answer option button widget with selection states.

**Acceptance Criteria:**
- [ ] Displays country name
- [ ] States: unselected, selected, correct, wrong, disabled
- [ ] Color coding: green for correct, red for wrong
- [ ] Callback on tap
- [ ] Disabled state after answer revealed
- [ ] Smooth color transition animation

**Files:**
- `lib/views/widgets/answer_option.dart`

---

### T018 — Create Feedback Overlay
| Field | Value |
|-------|-------|
| **ID** | T018 |
| **Phase** | 4 |
| **Depends On** | T015, T016, T017 |
| **Concurrent With** | T019 |
| **Estimated Effort** | 45 min |

**Description:**
Create the feedback overlay for correct/wrong answers.

**Acceptance Criteria:**
- [ ] Shows "+10", "+8", "+5", or "0" points animation
- [ ] Green overlay for correct answers
- [ ] Red overlay for wrong answers
- [ ] Auto-dismiss after 1.5 seconds
- [ ] "Next" button to proceed
- [ ] Correct answer highlighted after 3 failed attempts

**Files:**
- `lib/views/widgets/feedback_overlay.dart`

---

### T019 — Create Game Over Dialog
| Field | Value |
|-------|-------|
| **ID** | T019 |
| **Phase** | 4 |
| **Depends On** | T015, T016, T017 |
| **Concurrent With** | T018 |
| **Estimated Effort** | 30 min |

**Description:**
Create the game over dialog shown when all countries are solved.

**Acceptance Criteria:**
- [ ] Shows final score
- [ ] Shows total countries solved
- [ ] "Play Again" button triggers `resetGame()`
- [ ] Confetti or celebration animation (optional)
- [ ] Non-dismissible by tapping outside

**Files:**
- `lib/views/widgets/game_over_dialog.dart`

---

### T020 — Create Splash Screen
| Field | Value |
|-------|-------|
| **ID** | T020 |
| **Phase** | 4 |
| **Depends On** | T018, T019 |
| **Concurrent With** | None |
| **Estimated Effort** | 20 min |

**Description:**
Create splash/loading screen shown during initialization.

**Acceptance Criteria:**
- [ ] App logo or icon
- [ ] Loading indicator
- [ ] Auto-navigates to `GamePage` when `initialize()` completes
- [ ] Handles initialization errors

**Files:**
- `lib/views/splash_page.dart`

---

## Phase 5: Polish

### T021 — Add Animations and Haptic Feedback
| Field | Value |
|-------|-------|
| **ID** | T021 |
| **Phase** | 5 |
| **Depends On** | T020 |
| **Concurrent With** | None |
| **Estimated Effort** | 1 hour |

**Description:**
Add polish including animations, haptics, and micro-interactions.

**Acceptance Criteria:**
- [ ] Shake animation on wrong answer
- [ ] Pulse animation on correct answer
- [ ] Slide transition between questions
- [ ] Haptic feedback on answer selection
- [ ] Score counter animation
- [ ] Smooth page transitions

**Files:**
- `lib/views/widgets/answer_option.dart`
- `lib/views/widgets/feedback_overlay.dart`
- `lib/views/widgets/score_header.dart`

---

## Phase 6: Testing

### T022 — Integration Testing
| Field | Value |
|-------|-------|
| **ID** | T022 |
| **Phase** | 6 |
| **Depends On** | T021 |
| **Concurrent With** | None |
| **Estimated Effort** | 2 hours |

**Description:**
Create integration tests for the complete game flow.

**Acceptance Criteria:**
- [ ] Full game flow test: launch → answer → next → game over → reset
- [ ] Persistence test: answer questions, restart app, verify state restored
- [ ] Scoring test: verify 10/8/5/0 point logic end-to-end
- [ ] Solved exclusion test: verify solved countries don't reappear
- [ ] All tests pass in CI

**Files:**
- `integration_test/app_test.dart`

---

## Concurrent Execution Summary

The following tickets can be executed in parallel when their dependencies are met:

| Parallel Group | Tickets | Phase |
|----------------|---------|-------|
| **Group A** | T003, T004, T005 | 2 — Data Models |
| **Group B** | T006, T007 | 2 — Services |
| **Group C** | T008, T009 | 2 — Constants & Utils |
| **Group D** | T010, T011 | 2 — Theme & Constants |
| **Group E** | T015, T016, T017 | 4 — UI Widgets |
| **Group F** | T018, T019 | 4 — Overlays & Dialogs |

---

## Execution Order (Linear)

For sequential execution, tickets should be completed in this order:

```
T001 → T002 → T003 → T004 → T005 → T006 → T007 → T008 → T009 → T010 → T011 → T012 → T013 → T014 → T015 → T016 → T017 → T018 → T019 → T020 → T021 → T022
```

---

## Execution Order (Optimized with Concurrency)

For parallel execution, follow this schedule:

```
Step 1:  T001
Step 2:  T002
Step 3:  T003 + T004 + T005        (Group A — 3 concurrent)
Step 4:  T006 + T007                (Group B — 2 concurrent)
Step 5:  T008 + T009                (Group C — 2 concurrent)
Step 6:  T010 + T011                (Group D — 2 concurrent)
Step 7:  T012
Step 8:  T013
Step 9:  T014
Step 10: T015 + T016 + T017         (Group E — 3 concurrent)
Step 11: T018 + T019                (Group F — 2 concurrent)
Step 12: T020
Step 13: T021
Step 14: T022
```

**Total Steps:** 14 (vs 22 sequential)
**Time Savings:** ~36% reduction in calendar time

---

## Ticket Summary

| Phase | Tickets | Total Effort |
|-------|---------|--------------|
| 1 — Setup | T001, T002 | 45 min |
| 2 — Data Layer | T003–T012 | 3.5 hours |
| 3 — ViewModel | T013 | 2 hours |
| 4 — UI Layer | T014–T020 | 3.5 hours |
| 5 — Polish | T021 | 1 hour |
| 6 — Testing | T022 | 2 hours |
| **Total** | **22 tickets** | **~12.75 hours** |

---

*Tickets created: 2026-09-29*
