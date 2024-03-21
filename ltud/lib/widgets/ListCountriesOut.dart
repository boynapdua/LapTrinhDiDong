import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '/models/country.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'listCity.dart';
class LimitedCityList extends StatefulWidget {
  @override
  _LimitedCityListState createState() => _LimitedCityListState();
}

class _LimitedCityListState extends State<LimitedCityList> {
  List<Country> countriesData = [];

  @override
  void initState() {
    super.initState();
    fetchCountryData();
    // fetchCountryData().then((_) => setState(() {}));
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
    return FutureBuilder(
        future: fetchCountryData(),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.done) {
            if (countriesData.length < 10) {
              // Nếu countriesData không có đủ dữ liệu, bạn có thể hiển thị một widget khác thay vì ListView.
              return Center(
                child: Text('Không đủ dữ liệu'),
              );
            }
            return SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => CityList(countriesData[index].name)));
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 20,),
                          setImage(context, index),
                          SizedBox(width: 30,),
                          Text('${countriesData[index].name}', style: TextStyle(
                              fontSize: 26
                          ),),
                        ],
                      ),
                    )

                  );
                },
              ),
            );
          }
          // return Center(
          //   child: CircularProgressIndicator(),
          // );
        //}
    );
  }

}