import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_course/scoped-models/connected_products.dart';
import './../models/user.dart';

mixin UserModel on ConnectedProductsModel {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response response = await http.post('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyClI5xhSl0zHFWIvFU21n78MtjEeZOu7HU', body: json.encode(authData), headers: {'Content-Type': 'application/json'});
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if(responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication Succeeded!';
    } else if(responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if(responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final http.Response response = await http.post('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyClI5xhSl0zHFWIvFU21n78MtjEeZOu7HU', body: json.encode(authData), headers: {'Content-Type': 'application/json'});
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if(responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication Succeeded!';
    } else if(responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email is already exists';
    }
    isLoading = false;
    notifyListeners();
    print({'success': !hasError, 'message': message});
    return {'success': !hasError, 'message': message};
  }
}