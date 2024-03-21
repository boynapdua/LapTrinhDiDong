import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MySearch extends StatefulWidget {
  @override
  _MySearchState createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {
  late TextEditingController _controller;
  List<dynamic> searchResults = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$query'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        searchResults = jsonData['drinks'];
      });
    } else {
      setState(() {
        searchResults = [];
      });
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          onChanged: (value) {
            if (value.isNotEmpty) {
              _performSearch(value);
            } else {
              setState(() {
                searchResults = [];
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                setState(() {
                  searchResults = [];
                });
              },
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/');
          },
        ),
      ),
      body: searchResults.isNotEmpty
          ? ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          var cocktail = searchResults[index];
          return ListTile(
            title: Text(cocktail['strDrink']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CocktailDetails(cocktailId: cocktail['idDrink'])),
              );
            },
          );
        },
      )
          : Center(
        child: Text('No results found'),
      ),
    );
  }
}

class CocktailDetails extends StatelessWidget {
  final String cocktailId;

  const CocktailDetails({Key? key, required this.cocktailId}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocktail Details'),
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
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final cocktail = snapshot.data as Map<String, dynamic>;
              return SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        cocktail['strDrinkThumb'],
                        width: 200,
                        height: 200,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Ingredients:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildIngredientList(cocktail),
                    SizedBox(height: 20),
                    Text(
                      'Instructions:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      cocktail['strInstructions'],
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back'),
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

  Widget _buildIngredientList(cocktail) {
    List<Widget> ingredientWidgets = [];
    for (int i = 1; i <= 15; i++) {
      var ingredientKey = 'strIngredient$i';
      var measureKey = 'strMeasure$i';
      var ingredient = cocktail[ingredientKey];
      var measure = cocktail[measureKey];

      if (ingredient != null && ingredient.isNotEmpty) {
        var ingredientText = measure != null ? '$measure $ingredient' : ingredient;
        ingredientWidgets.add(
          Text(
            '• $ingredientText',
            style: TextStyle(fontSize: 16),
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
