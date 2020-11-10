import 'package:flutter/material.dart';
import 'package:flutter_course/pages/product_edit.dart';
import 'package:flutter_course/pages/product_list.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/ui_elements/logout_list_tile.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;

  ProductsAdminPage(this.model);
  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            }
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('Manage Products'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 3.0,
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
        children: [
          ProductEditPage(),
          ProductListPage(model)
        ],
      ),
    )
  );
  }
}