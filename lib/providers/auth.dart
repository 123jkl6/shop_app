import "dart:convert";
import "dart:async";
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

import 'package:shop_app/model/http_exception.dart';

import "../shared/url.dart";

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    print(_token);
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
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
    _token = responseBody["idToken"];
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

    print(_token);
    print(_userId);
    print(_expiryDate);

    _autoLogout();

    notifyListeners();

    final sharedPreferences = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String(),
      },
    );
    print(userData);
    sharedPreferences.setString("userData", userData);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    print(extractedUserData);
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);
    if (expiryDate.isBefore(DateTime.now())) {
      print("expired token " + expiryDate.toIso8601String());
      return false;
    }
    print("token is valid");
    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expiryDate = expiryDate;
    
    print("assigned token from SharedPreferences. ");
    print(_token);
    print(_userId);
    print(_expiryDate);

    notifyListeners();
    _autoLogout();

    return true;
  }

  void logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final expiryTime = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expiryTime), logout);
  }
}
