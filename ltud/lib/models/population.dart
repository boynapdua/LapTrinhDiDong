class PopulationData {
  String? city;
  String? country;
  List<PopulationCount>? populationCounts;

  PopulationData({this.city, this.country, this.populationCounts});

  PopulationData.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
    if (json['populationCounts'] != null) {
      populationCounts = <PopulationCount>[];
      json['populationCounts'].forEach((v) {
        populationCounts?.add(PopulationCount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['country'] = this.country;
    if (this.populationCounts != null) {
      data['populationCounts'] =
          this.populationCounts?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PopulationCount {
  String? year;
  String? value;

  PopulationCount({this.year, this.value});

  PopulationCount.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['value'] = this.value;
    return data;
  }
}
