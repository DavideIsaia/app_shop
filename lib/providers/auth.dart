import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String ACTION) async {
    const String API_KEY = "AIzaSyABTE2UBDjnmAryyyG95wd4rFp3zTW04Xc";
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$ACTION?key=$API_KEY';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final resp = json.decode(response.body);
      if (resp['error'] != null) {
        throw HttpException(resp['error']['message']);
      } else {}
    } catch (error) {
      throw error;
    }
    // print(json.decode(response.body));
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }
}
