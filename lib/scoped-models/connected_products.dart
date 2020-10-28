import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

mixin ConnectedProducts on Model {
  List<Product> products = [];
  User authenticatedUser;
  int selProductIndex;
}