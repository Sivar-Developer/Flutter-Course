import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_course/scoped-models/connected_products.dart';
import './../models/user.dart';

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password) {
    authenticatedUser = User(id: '3453466', email: email, password: password);
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response response = await http.post('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyClI5xhSl0zHFWIvFU21n78MtjEeZOu7HU', body: json.encode(authData), headers: {'Content-Type': 'application/json'});
    print(json.decode(response.body));
    return {'success': true, 'message': 'Authentication Succeeded!'};
  }
}