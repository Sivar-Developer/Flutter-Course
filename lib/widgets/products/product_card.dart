import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/products/address_tag.dart';
import 'package:flutter_course/widgets/products/price_tag.dart';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(product['image']),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Expanded(
                child: TitleDefault(product['title'])
              ),
              SizedBox(width: 8.0,),
              PriceTag(product['price'].toString())
            ],),
          ),
          AddressTag('Union Square, San Fransico'),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).primaryColor,
                iconSize: 30,
                onPressed: () => Navigator.pushNamed<bool>(context, '/product/' + productIndex.toString())
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                color: Colors.red,
                iconSize: 30,
                onPressed: () => Navigator.pushNamed<bool>(context, '/product/' + productIndex.toString())
              )
          ])
        ],
      ),
    );
  }
}
