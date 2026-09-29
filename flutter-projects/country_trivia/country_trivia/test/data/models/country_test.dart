import 'package:flutter_test/flutter_test.dart';
import 'package:country_trivia/data/models/country.dart';

void main() {
  group('Country', () {
    test('fromJson parses name.common and cca2 correctly', () {
      final json = {
        'name': {'common': 'Germany', 'official': 'Federal Republic of Germany'},
        'cca2': 'DE',
      };

      final country = Country.fromJson(json);

      expect(country.name, 'Germany');
      expect(country.isoCode, 'DE');
    });

    test('flagUrl returns correct URL with lowercase isoCode', () {
      const country = Country(name: 'Germany', isoCode: 'DE');

      expect(country.flagUrl, 'https://flagcdn.com/w320/de.png');
    });

    test('flagUrl handles already lowercase isoCode', () {
      const country = Country(name: 'France', isoCode: 'fr');

      expect(country.flagUrl, 'https://flagcdn.com/w320/fr.png');
    });

    test('equality is based on isoCode', () {
      const country1 = Country(name: 'Germany', isoCode: 'DE');
      const country2 = Country(name: 'Germany', isoCode: 'DE');
      const country3 = Country(name: 'France', isoCode: 'FR');

      expect(country1, country2);
      expect(country1, isNot(country3));
    });

    test('hashCode is based on isoCode', () {
      const country1 = Country(name: 'Germany', isoCode: 'DE');
      const country2 = Country(name: 'Germany', isoCode: 'DE');

      expect(country1.hashCode, country2.hashCode);
    });
  });
}
