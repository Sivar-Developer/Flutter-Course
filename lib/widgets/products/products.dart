import "package:flutter/material.dart";
import 'package:flutter_course/widgets/products/product_card.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products);

  Widget _buildProductList(BuildContext context) {
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
    return _buildProductList(context);
  }
}
