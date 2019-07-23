import "dart:convert";
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import 'package:shop_app/model/http_exception.dart';

import "../shared/url.dart";

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    final response = await http.post(
      Url.firebaseSignup,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );
    final responseBody = json.decode(response.body);
    print(responseBody);
    // if responseBody has error
    if (responseBody["error"] != null) {
      throw HttpException(responseBody["error"]["message"]);
    }
    _token = responseBody["idToken"];
    _userId = responseBody["localId"];
    _expiryDate = DateTime.now().add(
      Duration(
        seconds: int.parse(
          responseBody["expiresIn"],
        ),
      ),
    );
  }

  Future<void> signin(String email, password) async {
    final response = await http.post(
      Url.firebaseSignin,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );
    final responseBody = json.decode(response.body);
    print(responseBody);
  }
}
