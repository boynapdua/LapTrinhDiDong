import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cocktailDetail.dart';

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
                MaterialPageRoute(builder: (context) => CocktailDetails(cocktail: cocktail,)),
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

