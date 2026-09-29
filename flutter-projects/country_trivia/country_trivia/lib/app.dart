import 'package:flutter/material.dart';

import 'views/game_page.dart';
import 'core/theme/app_theme.dart';

/// Root application widget. Dependency injection is handled by the
/// [MultiProvider] in `main.dart`, which wraps this widget.
class CountryTriviaApp extends StatelessWidget {
  const CountryTriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country Trivia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const GamePage(),
    );
  }
}
