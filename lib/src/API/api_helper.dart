import 'dart:convert';
import 'dart:io';
import 'package:designui/src/Model/TrackingDTO.dart';
import 'package:designui/src/Model/imageDTO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:designui/src/Model/user_profileDTO.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_exception.dart';
import 'package:async/async.dart';

class ApiHelper {

  final String _baseUrl = "https://eventtrackingapi.azurewebsites.net/";

  // login api
  Future<dynamic> LoginAPI({@required String fbToken, String url}) async {
    Map<String, String> headers ={
      HttpHeaders.contentTypeHeader : "application/json",
    };
    Map<String, String> map = new Map();
    map['firebaseToken'] = fbToken;
    var response = await http.post(_baseUrl+url, headers: headers,
        body: jsonEncode(map)
    );
    return response;
  }

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

  // get list events user register
  Future<dynamic> getList(String url) async {
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

  Future<dynamic> put(String idStudent,String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    try {
      final response = await http.put(_baseUrl +url, headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': '*/*',
        'Authorization': 'Bearer '+token,
      },
        body: jsonEncode(<String, String>{
          'idStudents': idStudent,
        }),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  // update information of user
  Future<dynamic> putInfor(UserProfileDTO dto,String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    try {
      final response = await http.put(_baseUrl +url, headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
        'Authorization': 'Bearer '+token,
      },
        body: jsonEncode(<String, String>{
          'phone': dto.phone.toString(),
          'major': dto.major,
          'studentCode': dto.studentCode,
        }),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
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

  // tracking get location
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

  // user post img
  Future<dynamic> uploadImage(ImageDTO dto,String url) async {
    http.StreamedResponse response;
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token_data");

      var responseJson = http.MultipartRequest('POST', Uri.parse(_baseUrl+url));
      responseJson.fields['eventId']= dto.eventId.toString();
      responseJson.fields['latitude']= dto.latitude.toString();
      responseJson.fields['longitude']= dto.longitude.toString();

      var stream = new http.ByteStream(DelegatingStream.typed(dto.file.openRead()));
      var length = await dto.file.length();
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(dto.file.path));
      responseJson.files.add(multipartFile);

      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': '*/*',
        'Authorization': 'Bearer '+token,
      };

      responseJson.headers.addAll(headers);
      response = await responseJson.send();
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response.statusCode;
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