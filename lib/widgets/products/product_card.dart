import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/products/price_tag.dart';

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
                child: Text(
                  product['title'],
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oswald'
                  ),
                ),
              ),
              SizedBox(width: 8.0,),
              PriceTag(product['price'].toString())
            ],),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(6.0)
            ),
            child: Text('Union Square, San Fransico'),
          ),
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
