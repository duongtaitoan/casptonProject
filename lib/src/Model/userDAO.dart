import 'dart:convert';

import 'package:designui/src/API/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDao {

  static Future<String> login({@required String fbToken}) async {
    ApiHelper _api = new ApiHelper();
    var response = await _api.loginAPI(fbToken,"api/users/firebase-signin");
    try {
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final prefs = await SharedPreferences.getInstance();
        var tokenData = jsonDecode(response.body);
        prefs.setString("token_data", tokenData["data"]["token"]);
        return "Đăng nhập thành công";
      } else if (response.statusCode >= 400 && response.statusCode <= 401) {
        return "Địa chỉ email không hợp lệ\n Vd: example@fpt.edu.vn";
      }
    }catch(e){
      print('Error :'+e.toString());
    }
  }
}
