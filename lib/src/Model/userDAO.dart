import 'dart:convert';
import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/UserDTO.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDao {
  static Future login({@required String fbToken}) async {
    ApiHelper _api = new ApiHelper();
    var response = await _api.LoginAPI(fbToken: fbToken, url: "api/users/firebase-signin",);

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      final prefs = await SharedPreferences.getInstance();
      var tokenData = jsonDecode(response.body);
      prefs.setString("token_data", tokenData["data"]["token"]);
      return "Đăng nhập thành công";
    } else if (response.statusCode == 400) {
      return "Kiểm tra lại wifi trước khi kết nối ứng dụng";
    } else if (response.statusCode == 401) {
      return "Địa chỉ email không hợp lệ\n Vd: example@fpt.edu.vn";
    }
  }

  // get status of students
  static Future<int> getStatusRegister(int studentId) async{
    ApiHelper _api = new ApiHelper();
    dynamic response = await _api.get(" ....................... ${studentId}");
    var json = response["data"];
    return json.map((e) => UserDTO.fromJson(e));
  }
}
