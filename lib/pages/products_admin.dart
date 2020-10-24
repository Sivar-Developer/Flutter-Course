import 'package:flutter/material.dart';
import 'package:flutter_course/pages/product_list.dart';

import './product_create.dart';

class ProductsAdminPage extends StatelessWidget {
  final Function addProduct;
  final Function deleteProduct;

  ProductsAdminPage(this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              title: Text('All Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              }
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Manage Products'),
        bottom: TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.create),
              text: 'Create Products'
            ),
            Tab(
              icon: Icon(Icons.list),
              text: 'My Products'
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [ProductCreatePage(addProduct), ProductListPage()],
      ),
    )
  );
  }
}