import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CocktailListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCocktails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<dynamic> cocktails = snapshot.data as List<dynamic>;
            return ListView.builder(
              shrinkWrap: true, // Add this line
              itemCount: cocktails.length,
              itemBuilder: (context, index) {
                var cocktail = cocktails[index];
                return _buildCocktailTile(cocktail, context);
              },
            );
          }
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildCocktailTile(dynamic cocktail, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CocktailDetails(cocktailId: cocktail['idDrink'])),
              );
            },
            child: Text(
              cocktail['strDrink'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
        ),
      ),
    );
  }

  Widget _buildIngredientList(cocktail) {
    List<Widget> ingredientWidgets = [];
    for (var i = 1; i <= 3; i++) {
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

  Future<List<dynamic>> fetchCocktails() async {
    List<dynamic> cocktails = [];
    for (int response1 = 0; response1 <= 4; response1++) {
      final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        cocktails.add(jsonData['drinks'][0]);
      } else {
        throw Exception('Failed to load cocktails');
      }
    }
    return cocktails;
  }
}

class CocktailDetails extends StatelessWidget {
  final String cocktailId;

  const CocktailDetails({Key? key, required this.cocktailId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FutureBuilder(
            future: fetchCocktailDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                );
              } else {
                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  );
                } else {
                  final cocktail = snapshot.data as Map<String, dynamic>;
                  return Text(
                    cocktail['strDrink'],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  );
                }
              }
            },
          ),
        ),
        body: FutureBuilder(
        future: fetchCocktailDetails(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(
    child: CircularProgressIndicator(),
    );
    } else {
    if (snapshot.hasError) {
    return Center(
    child: Text(
    'Error: ${snapshot.error}',
    style: TextStyle(
    fontSize: 18,
    ),
    ),
    );
    } else {
    final cocktail = snapshot.data as Map<String, dynamic>;
    return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Image.network(
    cocktail['strDrinkThumb'],
    width: 200,
    height: 200,
    fit: BoxFit.cover,
    ),
    SizedBox(height: 20),
    Text(
    'Category: ${cocktail['strCategory']}',
    style: TextStyle(
    fontSize: 16,
    ),
    ),
    Text(
    'Glass Type: ${cocktail['strGlass']}',
    style: TextStyle(
    fontSize: 16,
    ),
    ),
    SizedBox(height: 10),
    Text(
    'Instructions:',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 10),
    Text(
    cocktail['strInstructions'],
    style:
    TextStyle(
      fontSize: 16,
    ),
    ),
    ],
    ),
    );
    }
    }
    },
        ),
    );
  }

  Future<Map<String, dynamic>> fetchCocktailDetails() async {
    final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$cocktailId'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final cocktail = jsonData['drinks'][0];
      return cocktail;
    } else {
      throw Exception('Failed to load cocktail details');
    }
  }
}
