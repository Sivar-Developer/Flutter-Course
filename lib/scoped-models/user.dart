import 'package:scoped_model/scoped_model.dart';

import './../models/user.dart';

mixin UserModel on Model {
  User _authenticatedUser;

  void login(String email, String password) {
    _authenticatedUser = User(id: '3453466', email: email, password: password);
  }
}