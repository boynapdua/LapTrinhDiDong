import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cocktailDetail.dart';

class OutstandingWidget extends StatefulWidget {
  @override
  _OutstandingWidgetState createState() => _OutstandingWidgetState();
}

class _OutstandingWidgetState extends State<OutstandingWidget> {
  List<dynamic> cocktails = [];
  Set<dynamic> favorites = Set<dynamic>();
  late http.Client httpClient;

  @override
  void initState() {
    super.initState();
    httpClient = http.Client();
    fetchCocktails();
  }

  @override
  void dispose() {
    httpClient.close(); // Đóng client khi không còn cần thiết nữa
    super.dispose();
  }

  Future<void> fetchCocktails() async {
    Set<String> seenCocktailNames = Set<String>();
    for(int response1 = 0; response1 <= 100; response1++) {
      final response = await httpClient.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        var drinkName = jsonData['drinks'][0]['strDrink'];
        if (!seenCocktailNames.contains(drinkName)) {
          seenCocktailNames.add(drinkName);
          if (mounted) { // Kiểm tra trước khi gọi setState()
            setState(() {
              cocktails.add(jsonData['drinks'][0]);
            });
          }
        }
      } else {
        throw Exception('Failed to load cocktails');
      }
    }
  }

  void _addCocktailToFirestore(dynamic cocktail) {
    FirebaseFirestore.instance.collection('cocktails').add({
      'strDrink': cocktail['strDrink'],
      'strDrinkThumb': cocktail['strDrinkThumb'],
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cocktail added to favourite cocktail')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add cocktail: $error')),
      );
    });
  }

  void _removeCocktailFromFirestore(dynamic cocktail) {
    FirebaseFirestore.instance.collection('cocktails').where('strDrink', isEqualTo: cocktail['strDrink']).get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cocktail removed from Firestore')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove cocktail: $error')),
      );
    });
  }
  Future<bool> _checkCocktailExists(String cocktailName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cocktails')
        .where('strDrink', isEqualTo: cocktailName)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    cocktails.sort((a, b) => a['strDrink'].compareTo(b['strDrink']));
    Color heartColor = Colors.red;
    return Scaffold(
      appBar: AppBar(
        title: Text('List Cocktail', textAlign: TextAlign.center),
      ),
      backgroundColor: Colors.black,
      body:  ListView.builder(
              itemCount: cocktails.length,
              itemBuilder: (context, index) {
                var cocktail = cocktails[index];
                bool isFavorite = favorites.contains(cocktail);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CocktailDetails(cocktail: cocktail)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(cocktail['strDrink']),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            cocktail['strDrinkThumb'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        subtitle: _buildIngredientList(cocktail),
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: heartColor,
                          ),
                          onPressed: () async {
                            isFavorite = await _checkCocktailExists(cocktail['strDrink']);
                            setState(() {
                              if (isFavorite) {
                                favorites.remove(cocktail);
                                _removeCocktailFromFirestore(cocktail);
                              } else {
                                favorites.add(cocktail);
                                _addCocktailToFirestore(cocktail);
                              }
                              heartColor = isFavorite ? Colors.white : Colors.red;
                            });
                            isFavorite = !isFavorite;
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),


    );
  }

  Widget _buildIngredientList(cocktail) {
    List<Widget> ingredientWidgets = [];
    for (var i = 1; i <= 15; i++) {
      var ingredientKey = 'strIngredient$i';
      var measureKey = 'strMeasure$i';
      var ingredient = cocktail[ingredientKey];
      var measure = cocktail[measureKey];

      if (ingredient != null && ingredient.isNotEmpty) {
        var ingredientText = measure != null ? '$measure $ingredient' : ingredient;
        ingredientWidgets.add(
          Text(
            ingredientText,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredientWidgets,
    );
  }
}



