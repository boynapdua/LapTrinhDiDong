import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ltud/models/city.dart';

class CityList extends StatefulWidget {
  final String? country;

  CityList(this.country);
  @override
  _CityListState createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  List<City> citiesData = [];
  List<String>? city = [];
  int i =0;
  @override
  void initState(){
    super.initState();
    fetchCityData();
  }



  Future<void> fetchCityData() async {
    var url = Uri.https('countriesnow.space', '/api/v0.1/countries');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['data'];
      List<City> cities = [];
      for (var cityJson in jsonData) {
        cities.add(City.fromJson(cityJson));
      }
      setState(() {
        citiesData = cities;

      });

    } else {
      print('Failed to load city data: ${response.statusCode}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        ),
        body: Column(
          children: [
            Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          SizedBox(
                            width: double.maxFinite,
                            height: 300,
                            child: ListView.builder(
                              itemCount: city?.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(city![index]),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}