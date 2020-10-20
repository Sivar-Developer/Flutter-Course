import "package:flutter/material.dart";

import './pages/product.dart';

class Products extends StatelessWidget {
  final List<Map> products;

  Products([this.products = const []]);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]['image']),
          Text(products[index]['title']),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductPage(products[index]['title'], products[index]['image'])
                  )
                ),
              )
          ])
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return products.length > 0
        ? ListView.builder(
            itemBuilder: _buildProductItem,
            itemCount: products.length,
          )
        : Center(
            child: Text('No Records'),
          );
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList(context);
  }
}
