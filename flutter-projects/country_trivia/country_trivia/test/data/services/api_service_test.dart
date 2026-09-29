import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:country_trivia/data/services/api_service.dart';

class _MockDio implements Dio {
  List<dynamic> responseData = [
    {
      'name': {'common': 'Germany', 'official': 'Federal Republic of Germany'},
      'cca2': 'DE',
    },
    {
      'name': {'common': 'France', 'official': 'French Republic'},
      'cca2': 'FR',
    },
  ];

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return Response<T>(
      data: responseData as T,
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('CountryApiServiceImpl', () {
    test('fetchAllCountries returns list of countries from API response', () async {
      final mockDio = _MockDio();
      final service = CountryApiServiceImpl(mockDio);

      final countries = await service.fetchAllCountries();

      expect(countries.length, 2);
      expect(countries[0].name, 'Germany');
      expect(countries[0].isoCode, 'DE');
      expect(countries[1].name, 'France');
      expect(countries[1].isoCode, 'FR');
    });

    test('fetchAllCountries filters out entries with empty isoCode', () async {
      final mockDio = _MockDio();
      mockDio.responseData = [
        {
          'name': {'common': 'Germany'},
          'cca2': 'DE',
        },
        {
          'name': {'common': 'Invalid'},
          'cca2': '',
        },
      ];
      final service = CountryApiServiceImpl(mockDio);

      final countries = await service.fetchAllCountries();

      expect(countries.length, 1);
      expect(countries[0].name, 'Germany');
    });

    test('fetchAllCountries filters out entries with empty name', () async {
      final mockDio = _MockDio();
      mockDio.responseData = [
        {
          'name': {'common': 'Germany'},
          'cca2': 'DE',
        },
        {
          'name': {'common': ''},
          'cca2': 'FR',
        },
      ];
      final service = CountryApiServiceImpl(mockDio);

      final countries = await service.fetchAllCountries();

      expect(countries.length, 1);
      expect(countries[0].name, 'Germany');
    });
  });
}
