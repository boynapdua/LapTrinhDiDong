class City {
  final String? city;
  final String? country;
  final List<PopulationCounts>? populationCounts;

  City({this.city, this.country, this.populationCounts});

  factory City.fromJson(Map<String, dynamic> json) {
    List<PopulationCounts>? populationCounts;

    if (json['populationCounts'] != null) {
      populationCounts = List<PopulationCounts>.from(json['populationCounts'].map((x) => PopulationCounts.fromJson(x)));
    }

    return City(
      city: json['city'],
      country: json['country'],
      populationCounts: populationCounts,
    );
  }
}

class PopulationCounts {
  final String? year;
  final String? value;

  PopulationCounts({this.year, this.value});

  factory PopulationCounts.fromJson(Map<String, dynamic> json) {
    return PopulationCounts(
      year: json['year'],
      value: json['value'],
    );
  }
}