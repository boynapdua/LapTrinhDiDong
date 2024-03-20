class Country {
  final String? name;
  final String? flag;

  Country({this.name, this.flag});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      flag: json['flag'],
    );
  }
}
