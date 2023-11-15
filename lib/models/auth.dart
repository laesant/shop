import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _uid;
  DateTime? _expiryDate;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token => isAuth ? _token : null;
  String? get email => isAuth ? _email : null;
  String? get userId => isAuth ? _uid : null;

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
    if (body['error'] != null) {
      throw AuthException(key: body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _uid = body['localId'];
      _expiryDate =
          DateTime.now().add(Duration(seconds: int.parse(body['expiresIn'])));
      notifyListeners();
    }
  }

  Future<void> signup({required String email, required String password}) =>
      _authenticate(email: email, password: password, urlFragment: 'signUp');
      
  Future<void> login({required String email, required String password}) =>
      _authenticate(
          email: email, password: password, urlFragment: 'signInWithPassword');

  void logout() {
    _token = null;
    _uid = null;
    _email = null;
    _expiryDate = null;
    notifyListeners();
  }
}
