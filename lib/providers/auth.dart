import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../models/httpException.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return (token != null);
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return token;
    }
    return null;
  }

  Future<void> authunticate(
      String email, String password, String _urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$_urlSegment?key=AIzaSyCXDhMFBcaoc1yFNTyqGEZe9p1dnLZm7L0');
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idtoken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp({String email, String password}) async {
    return authunticate(email, password, 'signUp');
  }

  Future<void> signIn({String email, String password}) async {
    return authunticate(email, password, 'signInWithPassword');
  }
}
