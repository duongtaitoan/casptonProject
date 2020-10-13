import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

class ApiHelper {

  final String _baseUrl = "https://jsonplaceholder.typicode.com/";
  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl, headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String title) async {
    var responseJson;
    try {
      print('title :'+title);
      final response = await http.put(_baseUrl , headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
        body: jsonEncode(<String, String>{
          'title': title,
        }),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  // Future<dynamic> post(UserDTO dto) async {
  //   var responseJson;
  //   try {
  //     final response = await http.post(_baseUrl+"posts/", headers: <String, String>{
  //       "Content-Type": "application/json; charset=UTF-8",
  //     },
  //       body: jsonEncode(<String,String>{
  //         'userId': dto.userId.toString(),
  //         'id': dto.id.toString(),
  //         'title': dto.title,
  //         'body': dto.body,
  //       }),
  //     );
  //     print("Ahihi URL: " + _baseUrl);
  //     print("Status code: " + response.statusCode.toString());
  //     responseJson = returnResponse(response);
  //   } on SocketException {
  //     throw FetchDataException('No Internet connection');
  //   }
  //   return responseJson;
  // }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = new Map<String, dynamic>();
        if(response.body.isNotEmpty){
          responseJson = json.decode(response.body);
          print(responseJson);
        }
        return responseJson;
      case 201:
        dynamic responseJson = new Map<String, dynamic>();
        if(response.body.isNotEmpty){
          responseJson = json.decode(response.body);
          print(responseJson);
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
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response
                .statusCode}');
    }
  }

  ApiHelper();
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}