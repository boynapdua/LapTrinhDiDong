import 'package:flutter/material.dart';
import 'package:ltud/models/search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ltud/widgets/cityDetail.dart';

class CitySearch extends StatefulWidget {
  const CitySearch({Key? key}) : super(key: key);

  @override
  State<CitySearch> createState() => _CitySearchState();
}

class _CitySearchState extends State<CitySearch> {
  late TextEditingController _controller;
  List<Search> cities = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    fetchCountryData();
  }

  Future<void> fetchCountryData() async {
    var url = Uri.https('countriesnow.space', '/api/v0.1/countries/population/cities');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['data'];
      List<Search> fetchedCities = [];
      for (var cityJson in jsonData) {
        fetchedCities.add(Search.fromJson(cityJson));
      }

      setState(() {
        cities = fetchedCities;
      });
    } else {
      print('Failed to load city data: ${response.statusCode}');
    }
  }

  void _performSearch(String query) {
    setState(() {
      cities = cities.where((city) => city.name?.toLowerCase().contains(query.toLowerCase()) ?? false).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          onChanged: (value) {
            if (value.isNotEmpty) {
              _performSearch(value);
            } else {
              setState(() {
                cities = [];
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                setState(() {
                  cities = [];
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CityDetail(cities[index].name)));
                  },
                  child: Text('${cities[index].name}'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CitySearch(),
  ));
}
