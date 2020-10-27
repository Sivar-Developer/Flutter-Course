import "package:flutter/material.dart";
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/products.dart';
import 'package:flutter_course/widgets/products/product_card.dart';
import 'package:scoped_model/scoped_model.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    return products.length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) => ProductCard(products[index], index),
            itemCount: products.length,
          )
        : Center(
            child: Text('No Records'),
          );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(builder: (BuildContext context, Widget child, ProductsModel model) {
      return _buildProductList(model.displayedProducts);
    },);
  }
}
