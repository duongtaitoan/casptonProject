import 'dart:convert';
import 'dart:io';
import 'package:designui/src/Model/TrackingDTO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_exception.dart';

class ApiHelper {

  final String _baseUrl = "https://192.168.1.113:45455/";
  // get list events
  Future<dynamic> get(String url) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    var responseJson;
    try {
      final response = await http.get(_baseUrl+url,  headers:
      {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+token,
      },
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  // Future<dynamic> put(String title) async {
  //   var responseJson;
  //   try {
  //     final response = await http.put(_baseUrl , headers: <String, String>{
  //       "Content-Type": "application/json; charset=UTF-8",
  //     },
  //       body: jsonEncode(<String, String>{
  //         'title': title,
  //       }),
  //     );
  //     responseJson = returnResponse(response);
  //   } on SocketException {
  //     throw FetchDataException('No Internet connection');
  //   }
  //   return responseJson;
  // }

  // get link api user

  Future<dynamic> LoginAPI({@required String fbToken, String url}) async {
    Map<String, String> headers ={
      HttpHeaders.contentTypeHeader : "application/json; charset=UTF-8",
    };
     Map<String, String> map = new Map();
     map['firebaseToken'] = fbToken;
     var response = await http.post(_baseUrl+url, headers: headers,
        body: jsonEncode(map)
     );
    return response;
  }

  // Future<dynamic> patch(String url, Map<String, dynamic> nameValues) async {
  //   var responseJson;
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   String token = sp.getString("token_data");
  //   try {
  //     final response = await http.patch(_baseUrl + url,
  //         headers: {
  //           'Content-Type': 'application/x-www-form-urlencoded',
  //           'accept': '*/*',
  //           'Authorization': 'Bearer '+token,
  //         },
  //         body: jsonEncode(nameValues));
  //     responseJson = returnResponse(response);
  //   } on SocketException {
  //     throw FetchDataException('No Internet connection');
  //   }
  //   return responseJson;
  // }

  // tracking
  Future<dynamic> postTracking(TrackingDTO dto,String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    try {
      final response = await http.post(_baseUrl+url,
        body: {
        "eventId": dto.eventId.toString(),
        "latitude": dto.latitude.toString(),
        "longitude": dto.longitude.toString(),
        }, headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'accept': '*/*',
          'Authorization': 'Bearer '+token,},
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  // user register events
  Future<dynamic> postRegisEvent(RegisterEventsDTO dto,String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    Map map = {'eventId': dto.eventId};
    try {
      final response = await http.post(_baseUrl+url,
        body:utf8.encode(json.encode(map))
        , headers: {
          'Content-Type': 'application/json',
          'Content-Length': '13',
          'accept': '*/*',
          'Authorization': 'Bearer '+token,},
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = new Map<String, dynamic>();
        if(response.body.isNotEmpty){
          responseJson = json.decode(response.body);
        }
        return responseJson;
      case 201:
        dynamic responseJson = new Map<String, dynamic>();
        if(response.body.isNotEmpty){
          responseJson = json.decode(response.body);
        }
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 511:
        throw ExpiredException(response.body.toString());
      case 500:
      default:
            print('value responseJson: '+response.request.method.toString());
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response
                .statusCode}');
    }
  }

  ApiHelper();
}
// blocked by firewall
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}