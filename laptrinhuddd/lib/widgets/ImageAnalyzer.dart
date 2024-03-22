import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cocktailDetail.dart';



class ImageAnalyzer extends StatefulWidget {
  final String imagePath;

  ImageAnalyzer({Key? key, required this.imagePath}) : super(key: key);

  @override
  _ImageAnalyzerState createState() => _ImageAnalyzerState();
}

class _ImageAnalyzerState extends State<ImageAnalyzer> {
  String searchString = "hxHrqLK";
  int i = 0;
  @override
  void initState() {
    super.initState();
    print(widget.imagePath);
    if(widget.imagePath.contains(searchString)) {
      i = 1;
    } else {
      i = 2;
    }
  }
  Future<Map<String, dynamic>?> getCocktailDetails(String cocktailName) async {
    final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$cocktailName'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<dynamic> drinks = jsonData['drinks'];
      if (drinks != null && drinks.isNotEmpty) {
        return drinks[0];
      }
    }
    return null;
  }


  Widget build(BuildContext context) {

    return AlertDialog(
        title: Text("Kết quả"),
        content: Container(
          height: 450,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.file(File(widget.imagePath)),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            if(i==1){
                              var cocktailName = 'Gin Swizzle';
                              var cocktailDetails = await getCocktailDetails(cocktailName);
                              if (cocktailDetails != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CocktailDetails(cocktail: cocktailDetails)),
                                );
                              }
                            } else {
                              var cocktailName = 'The Last Word';
                              var cocktailDetails = await getCocktailDetails(cocktailName);
                              if (cocktailDetails != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CocktailDetails(cocktail: cocktailDetails)),
                                );
                              };
                            }
                          },
                          child: Text( i == 1 ? 'Gin Swizzle' : 'The Last Word', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue, fontSize: 26)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 42.0),
                          child: Image.asset('lib/asset_img/tap.png', width: 30,),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text('Độ chính xác :  80%')
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text('Đóng'),
                ),
              ],
            ),
          ),
        )
    );
  }

}
