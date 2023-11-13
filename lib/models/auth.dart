import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  static const String _url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAJQZ28okUqnnsQWS7-w-I5JK5MkAgjKZY';
  Future<void> signup({required String email, required String password}) async {
    var response = await http.post(Uri.parse(_url),
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    print(jsonDecode(response.body));
  }
}
