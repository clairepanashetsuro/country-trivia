/// Represents a country with its name, ISO code, and flag URL.
class Country {
  /// Common name of the country (e.g., "Germany")
  final String name;

  /// ISO 3166-1 alpha-2 code (e.g., "DE")
  final String isoCode;

  /// URL for the flag image from flagcdn.com
  String get flagUrl => 'https://flagcdn.com/w320/${isoCode.toLowerCase()}.png';

  const Country({
    required this.name,
    required this.isoCode,
  });

  /// Creates a [Country] from JSON response of restcountries.com
  ///
  /// Expected format:
  /// ```json
  /// {
  ///   "name": { "common": "Germany", "official": "..." },
  ///   "cca2": "DE"
  /// }
  /// ```
  factory Country.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>;
    return Country(
      name: name['common'] as String,
      isoCode: json['cca2'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          isoCode == other.isoCode;

  @override
  int get hashCode => isoCode.hashCode;

  @override
  String toString() => 'Country(name: $name, isoCode: $isoCode)';
}
