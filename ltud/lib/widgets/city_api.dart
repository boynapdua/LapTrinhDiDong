import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ltud/models/city.dart';
import 'package:ltud/models/country.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CityList extends StatefulWidget {
  @override
  _CityListState createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  List<City> citiesData = [];
  List<Country> countriesData = [];

  @override
  void initState(){
    super.initState();
    fetchCountryData();
  }

  Future<void> fetchCountryData() async {
    var url = Uri.https('countriesnow.space', '/api/v0.1/countries/flag/images');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['data'];
      List<Country> countries = [];
      for (var countryJson in jsonData) {
        countries.add(Country.fromJson(countryJson));
      }

      setState(() {
        countriesData = countries;
      });
    } else {
      print('Failed to load city data: ${response.statusCode}');
    }
  }
  // Future<void> fetchCityData() async {
  //   var url = Uri.parse('https://countriesnow.space/api/v0.1/countries/population/cities');
  //   var response = await http.get(url);
  //
  //   if (response.statusCode == 200) {
  //     var jsonData = json.decode(response.body)['data'];
  //     List<City> cities = [];
  //     for (var cityJson in jsonData) {
  //       cities.add(City.fromJson(cityJson));
  //     }
  //
  //     setState(() {
  //       citiesData = cities;
  //     });
  //   } else {
  //     print('Failed to load city data: ${response.statusCode}');
  //   }
  // }
 setImage(BuildContext context, int index){
    if(countriesData[index].name == "Afghanistan") {
      return Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Flag_of_Afghanistan_%282013%E2%80%932021%29.svg/383px-Flag_of_Afghanistan_%282013%E2%80%932021%29.svg.png',
        width: 50,
        height: 50,
      );
    } else {
      return SvgPicture.network(
      '${countriesData[index].flag}',
        width: 50,
        height: 50,
       );
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
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                      itemCount: countriesData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                setImage(context, index),
                                SizedBox(height: 5,),
                                Text(
                                  '${countriesData[index].name ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                // if (citiesData[index].populationCounts != null)
                                //   Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: citiesData[index].populationCounts!.map((popCount) =>
                                //         Text('Year: ${popCount.year ?? ''}, Value: ${popCount.value ?? ''}',
                                //           style: TextStyle(
                                //             fontSize: 14,
                                //             color: Colors.grey,
                                //           ),
                                //         ),
                                //     ).toList(),
                                  //),
                              ],
                            ),
                          ),
                        );
                      },

                  )
              )
            ],
         ),
       ),
    );
  }
}