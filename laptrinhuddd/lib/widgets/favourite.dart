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
    return StreamBuilder<QuerySnapshot>(
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
        return ListView(
          children: snapshot.data!.docs.map((document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['strDrink']),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(data['strDrinkThumb']),
              ),
              onTap: () {
                // Điều hướng đến trang chi tiết của cocktail nếu cần
              },
            );
          }).toList(),
        );
      },
    );
  }
}

