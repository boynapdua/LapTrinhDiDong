import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    for(int response1 = 0; response1 <= 100; response1++) {
      final response = await httpClient.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (mounted) { // Kiểm tra trước khi gọi setState()
          setState(() {
            cocktails.add(jsonData['drinks'][0]);
          });
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
        SnackBar(content: Text('Cocktail added to Firestore')),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Cocktail', textAlign: TextAlign.center),
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
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
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isFavorite) {
                          favorites.remove(cocktail);
                          _removeCocktailFromFirestore(cocktail);
                        } else {
                          favorites.add(cocktail);
                          _addCocktailToFirestore(cocktail);
                        }
                      });
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

class CocktailDetails extends StatelessWidget {
  final dynamic cocktail;

  const CocktailDetails({Key? key, required this.cocktail}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail['strDrink']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                cocktail['strDrinkThumb'],
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildIngredientList(cocktail),
            SizedBox(height: 20),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              cocktail['strInstructions'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Glass Type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              cocktail['strGlass'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
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
            '• $ingredientText',
            style: TextStyle(
              fontSize: 14,
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
