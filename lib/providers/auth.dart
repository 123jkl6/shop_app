import "dart:convert";
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import 'package:shop_app/model/http_exception.dart';

import "../shared/url.dart";

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

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
