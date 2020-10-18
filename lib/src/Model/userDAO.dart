import 'dart:convert';

import 'package:designui/constants.dart';
import 'package:designui/src/Helper/http_dart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserDao {
  static Future<dynamic> getTokenData() async {
    var prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> tokenData;
    var tokenDataStr = prefs.getString("token_data");
    if (tokenDataStr != null) {
      tokenData = jsonDecode(tokenDataStr);
    }
    return tokenData;
  }

  static Future<void> clearTokenData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token_data");
  }

  static Future<void> login(
      {@required String fbToken,
      Function(Map<String, dynamic> tokenData) success,
      Function(List<String> mess) invalid,
      Function() invalidEmail,
      Function error}) async {
    var response = await loginAPI(fbToken: fbToken);
    try {
      if (response == 200) {
        print('{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{');
        print('Response body: ${response.body}');
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("token_data", response.body);
        var tokenData = jsonDecode(response.body);
        print('}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}');
        if (success != null) success(tokenData);
        return;
      } else if (response.statusCode == 400) {
        print('+999999999999999999999');
        var result = jsonDecode(response.body);
        print(result);
        var validationData = result["data"]["results"];
        var mess = <String>[];
        for (dynamic o in validationData)
          mess.add(o["message"] as String);
        if (invalid != null) invalid(mess);
        return;
      } else if (response.statusCode == 401) {
        if (invalidEmail != null) invalidEmail();
        return;
      }
      print(response.body);
      if (error != null) error();
    }catch(e){
      print('Error :'+e.toString());
    }
  }

  // get link api user
  static Future<http.Response> loginAPI({@required String fbToken}) async {
    final Uri uri = new Uri(scheme: "https", host: "10.0.2.2", port: int.parse("44351"), path: "api/users/firebase-signin");
    print('---'+uri.toString());
    // var uri = Uri.http(Constants.API_AUTH, "/api/users/firebase-signin");
    var response = await http.post(uri, headers: HttpHelper.commonHeaders(hasBody: true),
        body: jsonEncode({
          "firebaseToken": fbToken
        }));
    print('???????????????????????????????');
    print(response.toString() + '___________________________-');
    return response;
  }

}
