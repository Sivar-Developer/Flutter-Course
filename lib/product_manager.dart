import 'package:flutter/material.dart';

import './products.dart';

class ProductManager extends StatefulWidget {
  final String startingProduct;

  ProductManager({this.startingProduct});

  @override
  _ProductManagerState createState() => _ProductManagerState();
}

class _ProductManagerState extends State<ProductManager> {
  List<String> _products = [];

  @override
  void initState() {
    super.initState();
    _products.add(widget.startingProduct);
  }

  @override
  void didUpdateWidget(covariant ProductManager oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          margin: EdgeInsets.all(10.0),
          child: RaisedButton(
            child: Text('Add Product'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _products.add('Advanced food tester');
              });
            },
          )
        ),
        Products(_products)
    ]);
  }
}
