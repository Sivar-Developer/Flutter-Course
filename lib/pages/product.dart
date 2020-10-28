import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/products/address_tag.dart';
import 'package:flutter_course/widgets/products/price_tag.dart';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);

  Widget _buildTitlePriceRow(double price, String title) {
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
    }, child: ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      final Product product = model.allProducts[productIndex];
      return Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          Image.asset(product.image),
          _buildTitlePriceRow(product.price, product.title),
          AddressTag('Union Square, San Fransico'),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Text(
              product.description,
              textAlign: TextAlign.center
            )
          )
        ],
        ),
        );
      }) 
    );
  }
}