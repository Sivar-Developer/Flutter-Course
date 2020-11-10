import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_course/env/adaptive_theme.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/pages/map.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './widgets/helpers/custom_route.dart';

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
  final _platformChannel = MethodChannel('flutter-course.com/battery');

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await _platformChannel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level is ${result.toString()} %.';
    } catch (error) {
      batteryLevel = error.toString();
    }
    print(batteryLevel);
  }

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    _getBatteryLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        title: 'EasyList',
        theme: getAdaptiveThemeDta(context),
        routes: {
          '/': (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          '/map': (BuildContext context) => !_isAuthenticated ? AuthPage() : MapPage(),
          '/admin': (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsAdminPage(_model)
        },
        onGenerateRoute: (RouteSettings settings) {
          if(!_isAuthenticated) {
            return CustomRoute(
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
            return CustomRoute<bool>(
                        builder: (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductPage(product)
                      );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return CustomRoute(
            builder: (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          );
        },
        )
    );
  }
}
