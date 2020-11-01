import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
} 

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
          // brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepOrange,
          buttonColor: Colors.deepPurple,
          // buttonTheme: ButtonThemeData(textTheme: TextTheme())
          // fontFamily: 'Oswald'
        ),
        routes: {
          '/': (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          '/admin': (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsAdminPage(_model)
        },
        onGenerateRoute: (RouteSettings settings) {
          if(!_isAuthenticated) {
            return MaterialPageRoute(
            builder: (BuildContext context) => AuthPage(),
          );
          }
          final List<String> pathElement = settings.name.split('/');
          if(pathElement[0] != '') {
            return null;
          }
          if (pathElement[1] == 'product') {
            final String productId = pathElement[2];
            final Product product = _model.allProducts.firstWhere((Product product) => product.id == productId);
            return MaterialPageRoute<bool>(
                        builder: (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductPage(product)
                      );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          );
        },
        )
    );
  }
}
