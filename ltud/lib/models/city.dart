class City {
  final String? country;
  final List<String>? citiesName;

  City({ this.country, this.citiesName});

  factory City.fromJson(Map<String, dynamic> json) {

    return City(
      country: json['country'],
      citiesName: json['cities'].cast<String>(),
    );
  }
}

