import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ltud/models/city.dart';
import 'package:ltud/widgets/cityDetail.dart';

class CityList extends StatefulWidget {
  final String? country;

  CityList(this.country);
  @override
  _CityListState createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  List<City> citiesData = [];
  List<String> cities = [];
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
      List<City> citiesList = [];
      for (var cityJson in jsonData) {
        citiesList.add(City.fromJson(cityJson));
      }
      setState(() {
        citiesData = citiesList;
        cities.addAll(citiesData
            .where((city) => city.country == widget.country)
            .expand((city) => city.citiesName ?? []));
      });

    } else {
      print('Failed to load city data: ${response.statusCode}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('City ${widget.country}' ),
          // backgroundColor: Colors.green,
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
                              itemCount: cities!.length,
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                    onPressed: () {
                                      String x = cities![index];
                                      print(x);
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => CityDetail(x)));

                                    },
                                    child: Text(cities![index], style: TextStyle(fontSize: 24, color: Colors.black),)
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
      );

  }
}