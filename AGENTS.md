# AGENTS.md

## Repo layout (read this first — it is unusual)

The git repository root is **`/home/Student`** (the home directory), *not* the project folder.
There is no `.gitignore` at that root, and ~159 unrelated files (dotfiles, other projects)
show up as untracked/modified in every `git status`.

```
/home/Student/                                   <- GIT ROOT, remote: country-trivia
└── flutter-projects/country_trivia/             <- project folder (NOT a git root)
    ├── doc/                                     <- master_plan.md, tickets.md
    └── country_trivia/                          <- FLUTTER PACKAGE ROOT (pubspec.yaml here)
        ├── lib/
        ├── test/
        ├── pubspec.yaml
        └── analysis_options.yaml
```

**Always run Flutter commands from `/home/Student/flutter-projects/country_trivia/country_trivia`.**
Running `flutter test` / `flutter analyze` from any parent directory fails.

## Git safety

- The nested double `country_trivia/country_trivia` is real — verify with `git rev-parse --show-toplevel` if unsure.
- **Never** run `git add .` or `git add -A` from `/home/Student`; it would stage the entire home
  directory. Stage explicit paths instead:
  `git add country_trivia/lib/... country_trivia/test/...`
- Only these are tracked: `flutter-projects/country_trivia/**` (146 files).
- Branch workflow: one feature branch per ticket wave, PR'd into **`develop`**, never commit directly
  to `develop`. Name branches `feat/tXXX-...`.
- Remote is SSH: `git@github.com:clairepanashetsuro/country-trivia.git`.

## Commands

```bash
cd /home/Student/flutter-projects/country_trivia/country_trivia

flutter pub get
flutter analyze                 # must be clean before commit
flutter test                    # full suite
flutter test test/data/models/  # single directory
flutter test --plain-name "ScoreCalculator"   # single test by name
```

Order matters: `flutter analyze` then `flutter test`.

## Testing quirks

- **`test/widget_test.dart` is still the stock Flutter counter test** and references `MyApp` from
  `main.dart`. It passes today only because `main.dart` is still the default counter app. Replacing
  `main.dart` will break it — delete or rewrite it in the same change that introduces the real app.
- `SharedPreferences` tests require `SharedPreferences.setMockInitialValues({})` in `setUp()`,
  otherwise state leaks between tests.
- To mock `Dio`, use `class _MockDio implements Dio` + `@override dynamic noSuchMethod(...)`.
  Do **not** `extends Dio` — it has no unnamed constructor and forces you to implement ~20 methods.
  The working pattern is in `test/data/services/api_service_test.dart`.
- `mockito` and `build_runner` are in `pubspec.yaml` but **no generated `.mocks.dart` files exist
  yet**. Hand-written fakes are the current convention; don't assume codegen output is present.
- `flutter pub get` rewrites tracked generated files
  (`linux/flutter/generated_plugins.cmake`, `macos/Flutter/GeneratedPluginRegistrant.swift`,
  `windows/flutter/generated_plugins.cmake`). These legitimately appear dirty — commit them
  alongside the dependency change that caused them.

## Architecture (MVVM + Provider)

Layering is fixed; do not let UI call services or repositories directly.

```
views/          -> viewmodels/ -> data/services/ -> (Dio | SharedPreferences)
                     data/models/, data/enums/
core/           -> constants, theme, utils (no Flutter widget deps)
```

- `lib/viewmodels/` and `lib/views/` do not exist yet.
- `GameViewModel extends ChangeNotifier` is the single source of game state; every mutation ends in
  `notifyListeners()` via a private `_setState`.
- Models are immutable with `copyWith()`. `Country` equality/hashCode are based on `isoCode` only.
- Services are abstract-interface + Impl pairs, wired via `MultiProvider` in `main.dart`.

## Game rules that must not drift

- Scoring lives **only** in `core/utils/score_calculator.dart`: 1st attempt 10, 2nd 8, 3rd 5, failed 0.
  Do not reimplement these numbers anywhere else.
- A country counts as **solved** when the user answers correctly *or* burns all 3 attempts.
  Solved countries are persisted as ISO codes and must never be re-asked until `resetGame()`.
- A question is invalid unless it has exactly 4 options including the correct answer
  (`Question.isValid`). Guard against pools smaller than 4 countries.
- Persisted keys: `game_score` (int), `solved_countries` (List<String>) in `SharedPreferences`.

## Ticket workflow

- Plans and the authoritative ticket list live in `doc/master_plan.md` and `doc/tickets.md`.
  Re-read the relevant ticket's acceptance criteria before implementing it.
- Tickets are executed in waves. `doc/tickets.md` lists the concurrency groups — tickets in the
  same group have no dependency on each other and can be done together in one branch/PR.
- Completed: T001–T002, T003–T005, T006–T009. Next: T010 + T011 (concurrent), then T012, then T013.
- Each ticket's acceptance criteria is a checklist — verify each box, and include unit tests as the
  ticket requires, before raising the PR.
