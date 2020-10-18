import 'package:flutter/material.dart';
import 'package:flutter_course/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<String> _products = ['Food Tester'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Flutter Course'),
              backgroundColor: Colors.blue[900],
            ),
            body: Column(
              children: [
                Container(
                    margin: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      child: Text('Add Product'),
                      onPressed: () {
                        setState(() {
                          _products.add('Advanced food tester');
                        });
                      },
                  )
                ),
                Products(_products)
              ],
            )));
  }
}
