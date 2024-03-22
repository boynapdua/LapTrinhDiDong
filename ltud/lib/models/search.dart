class Search {
  final String? name;

  Search({this.name});

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      name: json['city'],
    );
  }
}
