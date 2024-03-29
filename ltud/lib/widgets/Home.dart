import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ltud/widgets/ListCountriesOut.dart';
import 'package:ltud/widgets/citySearch.dart';
import '/widgets/category.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearchFocused = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [


                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CitySearch()));
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Country",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      "Provide the right location",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  CarouselSlider(
                    items: [
                      Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/img/1.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/img/2.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/img/3.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/img/4.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ],
                    options: CarouselOptions(
                      height: 190,
                      aspectRatio: 16 / 8,
                      viewportFraction: 0.9,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 2),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      enlargeCenterPage: true,
                      enlargeFactor: 0.4,
                      reverse: true,
                    ),
                  ),

                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Main",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Category(),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Outstanding",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  LimitedCityList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
