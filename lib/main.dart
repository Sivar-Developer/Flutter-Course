import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './product_manager.dart';

void main() {
  debugPaintSizeEnabled = true;
  debugPrintLayouts = true;
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepOrange
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Course'),
        ),
        body: ProductManager(startingProduct: 'Food Tester Passed'),
      )
    );
  }
}
