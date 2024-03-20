class City {
  final String? country;
  final List<String>? cities;

  City({ this.country, this.cities});

  factory City.fromJson(Map<String, dynamic> json) {

    return City(
      country: json['country'],
      cities: json['cities'].cast<String>(),
    );
  }
}

