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
                MaterialPageRoute(builder: (context) => CocktailDetails(cocktail: cocktail)),
              );
            },
            child: Text(cocktail['strDrink']),
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
        ingredientWidgets.add(Row(
          children: [
            Text(
              '• ',
              style: TextStyle(fontSize: 12),
            ),
            Expanded(
              child: Text(
                ingredientText,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredientWidgets,
    );
  }

  Future<List<dynamic>> fetchCocktails() async {
    List<dynamic> cocktails = [];
    for (int response1 = 0; response1 <= 6; response1++) {
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
  final dynamic cocktail;

  const CocktailDetails({Key? key, required this.cocktail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail['strDrink']),
      ),
      body: Center(
        child: Text('Cocktail Details Page'),
      ),
    );
  }
}
