import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductFab extends StatefulWidget {
  final Product product;

  ProductFab(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFab> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200)
    );
    super.initState();
  }

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
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(0.2, 1.0, curve: Curves.easeOut)
              ),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).cardColor,
                heroTag: 'contact',
                mini: true,
                onPressed: () async {
                  final url = 'mailto:${widget.product.userEmail}';
                  if(await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch!';
                  }
                },
                child: Icon(Icons.mail, color: Theme.of(context).accentColor),
              ),
            ) 
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
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
              child: Icon(Icons.more_vert),
            ),
          ),
        ]
      );
    });
  }
}