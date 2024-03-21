import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import 'listCity.dart';

class favouriteList extends StatefulWidget {

  @override
  State<favouriteList> createState() => _favouriteListState();
}

class _favouriteListState extends State<favouriteList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favourite Country'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Countrys').snapshots(),
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
                    title: Text(data['country'], style: TextStyle(fontSize: 20),),
                    leading: Container(
                      height: 100,
                      width: 100,
                      child: SvgPicture.network(
                        '${data['image']}',
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => CityList(data['country'])));
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

