import 'dart:convert';
import 'package:flutter_course/models/user.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_course/scoped-models/connected_products.dart';
import 'package:flutter_course/models/auth.dart';

mixin UserModel on ConnectedProductsModel {
  Future<Map<String, dynamic>> authenticate(String email, String password, [AuthMode mode = AuthMode.Login]) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if(mode == AuthMode.Login) {
      response = await http.post('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyClI5xhSl0zHFWIvFU21n78MtjEeZOu7HU', body: json.encode(authData), headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyClI5xhSl0zHFWIvFU21n78MtjEeZOu7HU', body: json.encode(authData), headers: {'Content-Type': 'application/json'});
    }
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if(responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication Succeeded!';
      authenticatedUser = User(
        id: responseData['localId'],
        email: email,
        token: responseData['idToken']
      );
    } else if(responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email is already exists';
    } else if(responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if(responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }
}