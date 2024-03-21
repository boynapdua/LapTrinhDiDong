import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class favouriteList extends StatefulWidget {

  // final List<String> favouriteL;
  // favouriteList(this.favouriteL);
  @override
  State<favouriteList> createState() => _favouriteListState();
}

class _favouriteListState extends State<favouriteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Cocktails'),
      ),
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
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(data['strDrink'], style: TextStyle(fontSize: 20),),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(data['strDrinkThumb']),
                    ),
                    onTap: () {

                      },
                  ),
                );

              }).toList(),
            );


        },
      )
    );

  }
}

