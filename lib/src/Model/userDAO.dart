import 'dart:convert';
import 'package:designui/src/API/api_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDAO {
  static Future login({@required String fbToken, @required FirebaseUser user}) async {
    ApiHelper _api = new ApiHelper();
    var response = await _api.LoginAPI(fbToken: fbToken, url: "api/accounts/student/firebase-signin",);
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');

      final prefs = await SharedPreferences.getInstance();
      var tokenData = jsonDecode(response.body);

      prefs.setString("token_data", tokenData["data"]["token"]);
      prefs.setString("timeTo", tokenData["data"]["validTo"]);
      prefs.setString("timeFrom", tokenData["data"]["validFrom"]);
      var listUser = [user.uid,user.displayName,user.email];
      prefs.setStringList("firebase", listUser);

      return tokenData["message"];
    } else if (response.statusCode == 400 ) {
      return "Email address is not valid\n Vd: example@fpt.edu.vn";
    }
  }
}
