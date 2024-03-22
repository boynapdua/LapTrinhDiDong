import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CocktailDetails extends StatelessWidget {
  final dynamic cocktail;

  const CocktailDetails({Key? key, required this.cocktail}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail['strDrink']),
      ),
      backgroundColor: Color(0xFF232227),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
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
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:  SingleChildScrollView(
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
                  )
              )
          )
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