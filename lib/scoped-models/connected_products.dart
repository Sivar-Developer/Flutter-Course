import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

mixin ConnectedProductsModel on Model {
  List<Product> products = [];
  User authenticatedUser;
  String selProductId;
  bool isLoading  = false;
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isloading {
    return isLoading;
  }
}