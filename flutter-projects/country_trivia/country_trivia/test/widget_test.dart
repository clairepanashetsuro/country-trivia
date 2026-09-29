// Smoke test for app wiring. The stock Flutter counter test was removed when
// `main.dart` was replaced with the real Provider-based app (T012).
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:country_trivia/app.dart';
import 'package:country_trivia/data/models/country.dart';
import 'package:country_trivia/data/services/api_service.dart';
import 'package:country_trivia/data/services/game_state_repository.dart';
import 'package:country_trivia/viewmodels/game_viewmodel.dart';

class _FakeCountryApi implements CountryApiService {
  @override
  Future<List<Country>> fetchAllCountries() async => const [
        Country(name: 'Germany', isoCode: 'DE'),
        Country(name: 'France', isoCode: 'FR'),
        Country(name: 'Spain', isoCode: 'ES'),
        Country(name: 'Italy', isoCode: 'IT'),
        Country(name: 'Portugal', isoCode: 'PT'),
      ];
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('app builds and shows the game screen', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<CountryApiService>(create: (_) => _FakeCountryApi()),
          Provider<GameStateRepository>(create: (_) => GameStateRepositoryImpl()),
          ChangeNotifierProvider<GameViewModel>(
            create: (context) => GameViewModel(
              countryApi: context.read<CountryApiService>(),
              gameStateRepo: context.read<GameStateRepository>(),
            )..initialize(),
          ),
        ],
        child: const CountryTriviaApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Country Trivia'), findsOneWidget);
    expect(find.text('Score: 0'), findsOneWidget);
  });
}
