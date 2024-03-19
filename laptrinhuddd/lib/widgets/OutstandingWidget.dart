import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OutstandingWidget extends StatefulWidget {
  @override
  _MyCockTailState createState() => _MyCockTailState();
}

class _MyCockTailState extends State<OutstandingWidget> {
  List<dynamic> cocktails = [];
  Set<dynamic> favorites = Set<dynamic>();

  @override
  void initState() {
    super.initState();
    fetchCocktails();
  }

  Future<void> fetchCocktails() async {
    for(int response1 = 0; response1 <= 100; response1++) {
      final response = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          cocktails.add(jsonData['drinks'][0]);
        });
      } else {
        throw Exception('Failed to load cocktails');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Cocktail', textAlign: TextAlign.center),
      ),
      backgroundColor: Colors.black,
      body: cocktails.isEmpty ? _buildLoadingIndicator() : _buildCocktailList(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildCocktailList() {
    return ListView.builder(
      itemCount: cocktails.length,
      itemBuilder: (context, index) {
        var cocktail = cocktails[index];
        bool isFavorite = favorites.contains(cocktail);
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
              trailing: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {    ///////////////////////// xử lý logic luu mục yêu thích ở đây
                  setState(() {
                    if (isFavorite) {
                      favorites.remove(cocktail);
                    } else {
                      favorites.add(cocktail);
                    }
                  });
                },
              ),
            ),
          ),
        );
      },
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
