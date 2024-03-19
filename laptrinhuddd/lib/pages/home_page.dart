import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '/widgets/home_nav_bar.dart';
import '/widgets/CategoriesWidget.dart';
import '/widgets/OutStandingWidget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Color(0xFF232227),

        // homepage
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ///////////////////////////// Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.sort_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                  ),

                  /////////////////////////////// Text Header
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Cocktail Craze",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Delivers on Time",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //////////////////////////////// Slider
                  CarouselSlider(
                      items: [
                        Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('lib/asset_img/anh1.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('lib/asset_img/anh2.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('lib/asset_img/anh3.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('lib/asset_img/anh4.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        height: 190,
                        aspectRatio: 16 / 8,
                        viewportFraction: 0.7,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 2),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        enlargeCenterPage: true,
                        enlargeFactor: 0.4,
                        reverse: true,
                      )
                  ),

                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Main feature",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  ///////////////////////////////// Category
                  CategoryWidget(),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Outstanding",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  //Outstanding
                  //OutStandingWidget(),
                ],
              ),
            ),
          ],
        ),

        // home Navbar
        bottomNavigationBar: HomeNavBar(),
      ),
    );
  }
}
