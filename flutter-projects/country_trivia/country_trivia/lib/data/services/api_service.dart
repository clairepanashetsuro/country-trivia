import 'package:dio/dio.dart';
import '../models/country.dart';

/// Abstract interface for country API operations.
abstract class CountryApiService {
  /// Fetches all countries from the REST API.
  Future<List<Country>> fetchAllCountries();
}

/// Implementation of [CountryApiService] using Dio HTTP client.
class CountryApiServiceImpl implements CountryApiService {
  final Dio _dio;

  CountryApiServiceImpl(this._dio);

  @override
  Future<List<Country>> fetchAllCountries() async {
    final response = await _dio.get(
      'https://restcountries.com/v3.1/all',
      queryParameters: {'fields': 'name,cca2'},
    );

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map((json) => Country.fromJson(json as Map<String, dynamic>))
        .where((country) => country.isoCode.isNotEmpty && country.name.isNotEmpty)
        .toList();
  }
}
