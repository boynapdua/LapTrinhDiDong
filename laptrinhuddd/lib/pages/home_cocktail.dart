import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListCockTail extends StatelessWidget{
  const ListCockTail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cocktail App'),
        backgroundColor: Colors.purpleAccent,
        elevation: 0,
      ),
      //body: GetBuilder<>,
    );
  }
}