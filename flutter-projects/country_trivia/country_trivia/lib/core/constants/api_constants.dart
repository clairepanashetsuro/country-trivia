/// API-related constants for the Country Trivia app.
class ApiConstants {
  ApiConstants._();

  /// Base URL for the REST Countries API
  static const String countriesUrl = 'https://restcountries.com/v3.1/all';

  /// Query parameters to fetch only required fields
  static const String fields = 'name,cca2';

  /// Flag CDN URL template
  /// Replace {iso} with the lowercase ISO 3166-1 alpha-2 code
  static const String flagUrlTemplate = 'https://flagcdn.com/w320/{iso}.png';

  /// Flag image width in pixels
  static const int flagWidth = 320;

  /// Request timeout in seconds
  static const int timeoutSeconds = 30;
}
