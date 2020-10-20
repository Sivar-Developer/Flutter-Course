import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        Image.asset('assets/food.jpg'),
        Container(padding: EdgeInsets.all(10.0), child: Text('Details!'),),
        Container(
          padding: EdgeInsets.all(10.0),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text('Back'),
            onPressed: () => Navigator.pop(context)
          )
      )],),
    );
  }
}