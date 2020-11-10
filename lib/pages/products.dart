import 'package:flutter/material.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/products/products.dart';
import 'package:flutter_course/widgets/ui_elements/adaptive_progress_indicator.dart';
import 'package:flutter_course/widgets/ui_elements/logout_list_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

@override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> { 
  @override
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildSideDrawer(context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
            elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 3.0,
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          ListTile(
            leading: Icon(Icons.map_outlined),
            title: Text('Map'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/map');
            },
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }
  
  Widget _buildProductsList() {
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No Products Found'),);
      if(model.displayedProducts.length > 0 && !model.isLoading) {
        content = Products();
      } else if(model.isLoading) {
        content = Center(child: AdaptiveProgressIndicator());
      }
      return RefreshIndicator(onRefresh: model.fetchProducts, child: content);
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Home'),
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 3.0,
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoriteOnly ? Icons.favorite : Icons.favorite_outline), 
                onPressed: () => model.toggleDisplayMode(),
              );
            })
          ],
        ),
        body: _buildProductsList(),
      );
  }
}
