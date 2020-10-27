import 'package:flutter/material.dart';
import 'package:flutter_course/scoped-models/products.dart';
import 'package:flutter_course/widgets/products/products.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsPage extends StatelessWidget {

  Widget _buildSideDrawer(context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            ScopedModelDescendant<ProductsModel>(builder: (BuildContext context, Widget child, ProductsModel model) {
              return IconButton(
                icon: Icon(model.displayFavoriteOnly ? Icons.favorite : Icons.favorite_outline), 
                onPressed: () => model.toggleDisplayMode(),
              );
            })
          ],
        ),
        body: Products(),
      );
  }
}
