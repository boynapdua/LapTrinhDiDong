import 'package:flutter/material.dart';
import 'package:ltud/widgets/favourite.dart';
import '/widgets/country.dart';
import 'ListCountriesOut.dart';

class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // _buildCategoryButton(
          //   image: "lib/img/ngonngu.png",
          //   label: "Language",
          //   onPressed: () {
          //     LimitedCityList();
          //     print("button pressed");
          //   },
          // ),
          _buildCategoryButton(
            image: "lib/img/love.png",
            label: "Favorite",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => favouriteList()),
              );
              // Xử lý khi nút được nhấn
              print("button pressed");
            },
          ),
          _buildCategoryButton(
            image: "lib/img/countries.png",
            label: "Countries",
            onPressed: () {
              // Xử lý khi nút được nhấn
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CountryList()),
              );
              print("button pressed");
            },
          ),
          _buildCategoryButton(
            image: "lib/img/more.png",
            label: "More",
            onPressed: () {
              // Xử lý khi nút được nhấn
              print("button pressed");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton({required String image, required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white, // Màu nền của hình tròn
              radius: 30, // Đường kính của hình tròn
              child: CircleAvatar(
                backgroundImage: AssetImage(image),
                radius: 28, // Đường kính của hình ảnh trong hình tròn
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
