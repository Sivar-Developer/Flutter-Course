import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_course/scoped-models/main.dart';

class ProductFab extends StatefulWidget {
  final Product product;

  ProductFab(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFab> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainModel model) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 60.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'contact',
              mini: true,
              onPressed: () {},
              child: Icon(Icons.mail, color: Theme.of(context).accentColor),
            ),
          ),
          Container(
            height: 60.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'favorite',
              mini: true,
              onPressed: () {
                model.toggleProductFavoriteStatus();
              },
              child: Icon(
                model.selectedProduct.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor
              ),
            ),
          ),
          Container(
            height: 70.0,
            width: 56.0,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              heroTag: 'options',
              onPressed: () {},
              child: Icon(Icons.more_vert),
            ),
          ),
        ]
      );
    });
  }
}