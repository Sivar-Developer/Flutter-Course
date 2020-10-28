import 'package:flutter_course/scoped-models/connected_products.dart';
import './../models/user.dart';

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    authenticatedUser = User(id: '3453466', email: email, password: password);
  }
}