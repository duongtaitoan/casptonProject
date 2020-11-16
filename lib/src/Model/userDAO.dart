import 'dart:convert';
import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/userDTO.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDAO {
  static Future login({@required String fbToken}) async {
    ApiHelper _api = new ApiHelper();
    var response = await _api.LoginAPI(fbToken: fbToken, url: "api/users/firebase-signin",);
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');

      final prefs = await SharedPreferences.getInstance();
      var tokenData = jsonDecode(response.body);
      prefs.setString("token_data", tokenData["data"]["token"]);

      print('${tokenData["message"]} ------------------------------------------');
      return tokenData["message"];
    } else if (response.statusCode == 400) {
      return "Check in wifi before connecting the app";
    } else if (response.statusCode == 401) {
      return "Email address is not valid\n Vd: example@fpt.edu.vn";
    }
  }

  // get flow to id event
  Future<List<UserDTO>> getStatus(int id) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/registrations/${id}");
    var eventJson = json["data"] as List;
    return eventJson.map((e) => UserDTO.fromJson(e)).toList();
  }

  // get flow id of student
  Future<List<UserDTO>> getListStatusEvents(bool check) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/registrations?OnlyRegistered=${check}");
    var eventJson = json["data"] as List;
    return eventJson.map((e) => UserDTO.fromJson(e)).toList();
  }

}
