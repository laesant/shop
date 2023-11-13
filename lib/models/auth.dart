import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  static const String _url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAJQZ28okUqnnsQWS7-w-I5JK5MkAgjKZY';

  Future<void> _authenticate(
      {required String email,
      required String password,
      required String urlFragment}) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyAJQZ28okUqnnsQWS7-w-I5JK5MkAgjKZY';

    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);
    print(body);
    if (body['error'] != null) {
      throw AuthException(key: body['error']['message']);
    }
  }

  Future<void> signup({required String email, required String password}) =>
      _authenticate(email: email, password: password, urlFragment: 'signUp');
  Future<void> login({required String email, required String password}) =>
      _authenticate(
          email: email, password: password, urlFragment: 'signInWithPassword');
}
