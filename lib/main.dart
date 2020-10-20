import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

import 'pages/auth.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPrintLayouts = true;
  // debugPaintPointersEnabled = true;
  // debugPaintBaselinesEnabled = true;
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowMaterialGrid: true,
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepOrange
      ),
      home: AuthPage(),
    );
  }
}
