import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/products/address_tag.dart';
import 'package:flutter_course/widgets/products/price_tag.dart';
import 'package:flutter_course/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard(this.product);

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: TitleDefault(product.title)
          ),
          Flexible(
            child: SizedBox(width: 8.0,),
          ),
          Flexible(
            child: PriceTag(product.price.toString())
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            color: Theme.of(context).primaryColor,
            iconSize: 30,
            onPressed: () {
              model.selectProduct(product.id);
              Navigator.pushNamed<bool>(context, '/product/' + product.id).then((_) => model.selectProduct(null));
            }
          ),
          IconButton(
              icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Colors.red,
              iconSize: 30,
              onPressed: () {
                model.selectProduct(product.id);
                model.toggleProductFavoriteStatus();
              }
            )
          ]
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Hero(
            tag: product.id,
            child: FadeInImage(
              image: NetworkImage(product.image),
              placeholder: AssetImage('assets/placeholder.png'),
            ),
          ),
          _buildTitlePriceRow(),
          AddressTag(product.location.address),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
