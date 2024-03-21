import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ltud/models/city.dart';
import 'package:ltud/models/country.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'listCity.dart';

class CountryList extends StatefulWidget {
  @override
  _CountryListListState createState() => _CountryListListState();
}

class _CountryListListState extends State<CountryList> {
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
 setImage(BuildContext context, int index){
    if(countriesData[index].name == "Afghanistan") {
      return Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Flag_of_Afghanistan_%282013%E2%80%932021%29.svg/383px-Flag_of_Afghanistan_%282013%E2%80%932021%29.svg.png',
        width: 100,
        height: 100,
      );
    } else {
      return Container(
        height: 100,
        width: 100,
        child: SvgPicture.network(
          '${countriesData[index].flag}',
        ),
      );

 }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
           title: Text('Country'),
           // backgroundColor: Colors.green,
         ),
         body: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                      itemCount: countriesData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity, // Đặt chiều rộng của Container là không giới hạn để nó căn đủ theo chiều rộng của màn hình
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0), // Đặt bo góc cho Container thành hình chữ nhật
                            color: Colors.grey[100], // Màu nền của Container
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => CityList(countriesData[index].name)));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent, // Xóa màu nền của ElevatedButton
                              elevation: 0, // Xóa độ nâng của ElevatedButton
                              alignment: Alignment.centerLeft, // Đặt alignment về trái
                              side: BorderSide.none, // Xóa viền
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                setImage(context, index),
                                SizedBox(height: 30, width: 15,),

                                Text(
                                  '${countriesData[index].name ?? ""}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                        );
                      },

                  )
              )
            ],
         ),
       );

  }
}