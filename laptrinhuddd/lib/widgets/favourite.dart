import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'cocktailDetail.dart';
import 'dart:convert';
class favouriteList extends StatefulWidget {

  // final List<String> favouriteL;
  // favouriteList(this.favouriteL);
  @override
  State<favouriteList> createState() => _favouriteListState();
}

class _favouriteListState extends State<favouriteList> {
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
  void _removeCocktailFromFirestore(String x) {
    FirebaseFirestore.instance.collection('cocktails').doc(x).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cocktail removed Favourite')),
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
        title: Text('Favourite Cocktails'),
      ),
      backgroundColor: Color(0xFF232227),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cocktails').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No cocktails found'),
            );
          }
          // setState(() {});
          return  ListView(
              children: snapshot.data!.docs.map((document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return Dismissible(
                    key: Key(document.id),
                    onDismissed: (direction) {
                      // Xóa ghi chú khi người dùng vuốt để xóa
                      setState(() {
                        _removeCocktailFromFirestore(document.id);
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
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
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(data['strDrink'], style: TextStyle(fontSize: 20),),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(data['strDrinkThumb']),
                        ),
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => CocktailDetails(cocktail: data,)),
                          // );
                        },
                      ),
                    ),
                );


              }).toList(),
            );


        },
      )
    );

  }
}

