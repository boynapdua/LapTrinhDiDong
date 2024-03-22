import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ltud/models/population.dart';

class CityDetail extends StatefulWidget {
  final String? city;

  CityDetail(this.city);
  @override
  _CityDetailState createState() => _CityDetailState();
}

class _CityDetailState extends State<CityDetail> {
  PopulationData? selectedCity;

  @override
  void initState() {
    super.initState();
    //fetchCityData();
    futurePopulationData = fetchPopulationData();
  }
  late Future<List<PopulationData>> futurePopulationData;
  Future<List<PopulationData>> fetchPopulationData() async {
    final response = await http.get(Uri.parse('https://countriesnow.space/api/v0.1/countries/population/cities'));

    if (response.statusCode == 200) {
      List<PopulationData> populationDataList = [];
      var data = json.decode(response.body);
      for (var item in data['data']) {
        // populationDataList.add(PopulationData.fromJson(item));
        PopulationData populationData = PopulationData.fromJson(item);
        if (populationData.city == widget.city) {
          populationDataList.add(populationData);
        }
      }
      return populationDataList;
    } else {
      throw Exception('Failed to load population data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCity?.city ?? 'City Detail'),
      ),
      body: Center(
        child: FutureBuilder<List<PopulationData>>(
          future: futurePopulationData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child:  Text('Chưa có dữ liệu'),
              );
            }
            else {
                return  Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 500,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        List<String> populationInfo = [];
                        if (snapshot.data![index].populationCounts != null) {
                          snapshot.data![index].populationCounts!.forEach((element) {
                            populationInfo.add('Năm: ${element.year}: ${element.value}');
                          });
                        }
                        return Container(
                          height: 200,
                          child: ListTile(
                              title: Text('City: ' + '${snapshot.data![index].city ?? ''}', style: TextStyle(fontSize: 16),),
                              subtitle: Text('Country: ' +'${snapshot.data![index].country ?? ''}', style: TextStyle(fontSize: 16),),
                              trailing:  IntrinsicHeight(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: populationInfo
                                        .map((info) => Text(info))
                                        .toList(),
                                  ),
                                ),
                              )




                          ) ,
                        );

                      },
                    ),
                  ),
                );



            }
          },
        ),
      ),
    );
  }
}
