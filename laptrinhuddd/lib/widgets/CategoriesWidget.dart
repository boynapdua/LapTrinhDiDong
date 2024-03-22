import 'package:flutter/material.dart';
import 'package:laptrinhuddd/widgets/favourite.dart';
import 'package:laptrinhuddd/widgets/video.dart';
import '/widgets/OutstandingWidget.dart';
class CategoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryButton(
            image: "lib/asset_img/shopping.png",
            label: "Video",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => videoCocktail()),
              );
              print("Shopping button pressed");
            },
          ),
          _buildCategoryButton(
            image: "lib/asset_img/love.png",
            label: "Favorite",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => favouriteList()),
              );
              print("Love button pressed");
            },
          ),
          _buildCategoryButton(
            image: "lib/asset_img/cocktail.png",
            label: "CockTail",
            onPressed: () {
              // Xử lý khi nút được nhấn
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OutstandingWidget()),
              );
              print("Cocktail button pressed");
            },
          ),
          _buildCategoryButton(
            image: "lib/asset_img/more.png",
            label: "More",
            onPressed: () {
              // Xử lý khi nút được nhấn
              print("Shopping button pressed");
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
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Image.asset(
                image,
                width: 60,
                height: 60,
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
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
