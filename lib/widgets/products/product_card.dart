import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/products/address_tag.dart';
import 'package:flutter_course/widgets/products/price_tag.dart';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TitleDefault(product.title)
          ),
          SizedBox(width: 8.0,),
          PriceTag(product.price.toString())
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) { 
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          color: Theme.of(context).primaryColor,
          iconSize: 30,
          onPressed: () => Navigator.pushNamed<bool>(context, '/product/' + productIndex.toString())
        ),
        ScopedModelDescendant(builder: (BuildContext context, Widget child, MainModel model) {
          return IconButton(
            icon: Icon(model.allProducts[productIndex].isFavorite ? Icons.favorite : Icons.favorite_border),
            color: Colors.red,
            iconSize: 30,
            onPressed: () {
              model.selectProduct(productIndex);
              model.toggleProductFavoriteStatus();
            }
          );
        })
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.network(product.image),
          _buildTitlePriceRow(),
          AddressTag('Union Square, San Fransico'),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
