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
  final String _baseUrl = "http://3.34.246.228:23456/";

  // login api
  Future<dynamic> LoginAPI({@required String fbToken, String url}) async {
    Map<String, String> headers ={
      HttpHeaders.contentTypeHeader : "application/json",
    };
    var response = await http.post(_baseUrl+url, headers: headers,
        body: fbToken
    );
    return response;
  }

  // get list events
  Future<dynamic> get(String url) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    var responseJson;
    try {
      final response = await http.get(_baseUrl+url,
        headers: {
        'Content-Type': 'application/json ; charset=utf-8',
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

  // get id events
  Future<dynamic> getIdEvent(String url) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    var responseJson;
    var response;
    try {
      response = await http.get(_baseUrl+url,
        headers: {
          'Content-Type': 'application/json ; charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer '+token,
        },
      );
      responseJson = new Map<String, dynamic>();
      if(response.body.isNotEmpty){
        responseJson = json.decode(utf8.decode(response.bodyBytes));
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  // get id events
  Future<dynamic> getHashNoti(String url) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    var response;
    try {
      response = await http.get(_baseUrl+url,
        headers: {
          'Content-Type': 'application/json ; charset=utf-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer '+token,
        },
      );
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response.body;
  }

  // update
  Future<dynamic> put(String status ,String url, bool isCheckin) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    try {
      final response = await http.put(_baseUrl +url, headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
        'Authorization': 'Bearer '+token,
      },
        body: jsonEncode({
          'checkedIn': isCheckin,
          'status': status,
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
    var response;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    try {
        response = await http.put(_baseUrl +url, headers: <String, String>{
        'Content-Type': 'application/json',
        'accept': '*/*',
        'Authorization': 'Bearer '+token,
      },
        body: jsonEncode(<String, String>{
          'id':dto.id.toString(),
          'phoneNumber': dto.phone.toString(),
          'major': dto.major,
          'studentId': dto.studentCode,
          'preferredName':dto.fullName,
          'semester': dto.semester
        }),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return response.statusCode;
  }

  // tracking location
  Future<dynamic> postTracking(TrackingDTO dto,String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    Map map = {
      "eventId": dto.eventId.toString(),
      "address": dto.address.toString(),
      "studentId": dto.studentId.toString(),
      "latitude": dto.latitude.toString(),
      "longitude": dto.longitude.toString(),
    };
    try {
      final response = await http.post(_baseUrl+url,
        body: utf8.encode(json.encode(map)), headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'accept': '*/*',
          'Authorization': 'Bearer '+token,},
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  // tracking location first
  Future<dynamic> postTrackingFirst(lat,long,address,checkinQR,String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    Map map = {
      "latitude": lat.toString(),
      "longitude": long.toString(),
      "address": address.toString(),
      "checkInQRCode": checkinQR.toString(),
    };
    try {
      final response = await http.post(_baseUrl+url,
        body: utf8.encode(json.encode(map)), headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'accept': '*/*',
          'Authorization': 'Bearer '+token,},
      );

      responseJson = new Map<String, dynamic>();
      if(response.body.isNotEmpty){
        responseJson = json.decode(utf8.decode(response.bodyBytes));
      }
      // responseJson = returnResponse(response);
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
    Map map = {
      'eventId': dto.eventId,
      'semester': dto.semester,
      'studentId': dto.studentId
    };
    try {
      final response = await http.post(_baseUrl+url,
        body:utf8.encode(json.encode(map))
        , headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Authorization': 'Bearer '+token,},
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  // feed back events
  Future<dynamic> postFeedBack(eventId,studentId,now,valueBody,String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");

    Map map = {
      'eventId': eventId,
      'studentId': studentId,
      'recordedAt': now,
      'answers': valueBody
    };
    try {
      final response = await http.post(_baseUrl+url,
        body:utf8.encode(json.encode(map))
        , headers: {
          'Content-Type': 'application/json',
          "Accept": "*/*",
          'Authorization': 'Bearer '+token,},
      );
      responseJson = new Map<String, dynamic>();
      if(response.body.isNotEmpty){
        responseJson = json.decode(utf8.decode(response.bodyBytes));
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  // get location of event
  Future<dynamic> postLocation(String preferredName,String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    Map map = {
      'query': "preferredName == '${preferredName}'",
      'sorts': {},
    };
    try {
      final response = await http.post(_baseUrl+url,
        body:utf8.encode(json.encode(map))
        , headers: {
          'Content-Type': 'application/json',
          "Accept": "*/*",
          'Authorization': 'Bearer '+token,},
      );

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  // get 10 event
  Future<dynamic> postEvents(String status,int size,String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    Map map;
    if(size == null){
      map = {
        "query": "status == '${status}'",
        "sorts": {}
      };
    } else if(status == "DELETED"){
      map = {
        "query": "status != '${status}'",
        "page":size,
        "size": 10,
        "sorts": {}
      };
    } else if(status == "UPCOMING"){
      map = {
        "query": "status == '${status}'",
        "page":size,
        "size": 5,
        "sorts": {}
      };
    }else {
      map = {
        "query": "status == '${status}'",
        "page": size,
        "size": 10,
        "sorts": {}
      };
    }
    try {
      final response = await http.post(_baseUrl+url,
        body:utf8.encode(json.encode(map))
        , headers: {
          'Content-Type': 'application/json',
          "Accept": "*/*",
          'Authorization': 'Bearer '+token,},
          encoding: Encoding.getByName("utf-8")
      );
      responseJson = new Map<String, dynamic>();
      if(response.body.isNotEmpty){
        responseJson = json.decode(utf8.decode(response.bodyBytes));
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  // post event by Status
  Future<dynamic> postEventsByStatus(String status,String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    Map map;
    DateTime now = DateTime.now();
    if(status.compareTo("WAITING_FOR_APPROVAL")==0){
      map = {
        "query": "status == '${status}' or status == 'IN_WISHLIST'",
        "sorts": {}
      };
    } else {
      map = {
          "query": "status == '${status}' and requestedAt <= '${now.toUtc().toIso8601String()}'",
          "sorts": {}
        };
      };

    try {
      final response = await http.post(_baseUrl+url,
          body:utf8.encode(json.encode(map))
          , headers: {
            'Content-Type': 'application/json',
            "Accept": "*/*",
            'Authorization': 'Bearer '+token,},
          encoding: Encoding.getByName("utf-8")
      );
      responseJson = new Map<String, dynamic>();
      if(response.body.isNotEmpty){
        responseJson = json.decode(utf8.decode(response.bodyBytes));
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  // get events follow week
  Future<dynamic> postWeekEvents(String start,String end,String status,String url) async {
    var responseJson;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    Map map = {
      "query": "startTime >= '${start}' and endTime <= '${end}' and status == '${status}'",
      "size": 10,
      "sorts": {}
    };
    try {
      final response = await http.post(_baseUrl+url,
        body:utf8.encode(json.encode(map))
        , headers: {
          'Content-Type': 'application/json; charset=utf-8',
          "Accept": "*/*",
          'Authorization': 'Bearer '+token,},
          encoding:Encoding.getByName('utf-8')
      );
      // responseJson = returnResponse(response);
      responseJson = new Map<String, dynamic>();
      if(response.body.isNotEmpty){
        responseJson = json.decode(utf8.decode(response.bodyBytes));
      }
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
        // print('value responseJson: '+response.request.method.toString() +'---'+response.statusCode.toString()+''+response.body);
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