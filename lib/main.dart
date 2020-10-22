import 'package:flutter/material.dart';

import 'pages/auth.dart';
import './pages/products_admin.dart';

void main() {
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepOrange
      ),
      routes: {
        '/': (BuildContext context) => AuthPage(),
        '/admin': (BuildContext context) => ProductsAdminPage()
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElement = settings.name.split('/');
        if(pathElement[0] != '') {
          return null;
        }
        if (pathElement[1] == 'product') {
          final int index = int.parse(pathElement[2]);
          return MaterialPageRoute(
                      builder: (BuildContext context) => ProductPage(products[index]['title'], products[index]['image'])
                    );
        }
        return null;
      },
    );
  }
}
