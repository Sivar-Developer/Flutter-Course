import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/products/address_tag.dart';
import 'package:flutter_course/widgets/products/price_tag.dart';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final double price;
  final String imageUrl;

  ProductPage(this.title, this.price, this.imageUrl);

  _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This action cannot be undone!'),
          actions: <Widget>[
            FlatButton(
              child: Text('DISCARD'),
              onPressed: () {
                Navigator.pop(context);
              }
            ),
            FlatButton(
              child: Text('CONTINUE'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              }
            )
          ]
        );
      }
    );
  }

  Widget _buildTitlePriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      Expanded(
        child: TitleDefault(title)
      ),
      SizedBox(width: 8.0,),
      PriceTag(price.toString()),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      print('Back button pressed!');
      Navigator.pop(context, false);
      return Future.value(true);
    }, child: Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        Image.asset(imageUrl),
        _buildTitlePriceRow(),
        AddressTag('Union Square, San Fransico'),
        Container(
          padding: EdgeInsets.all(10.0),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text('Delete'),
            onPressed: () => _showWarningDialog(context)
          )
        )
      ],
      ),
      )
    );
  }
}