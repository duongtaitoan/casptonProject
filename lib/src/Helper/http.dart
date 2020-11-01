import 'package:designui/src/ViewModel/login_viewmodel.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static Map<String, String> headers(
      {List<MapEntry> entries, bool body = false}) {
    var map = <String, String>{};
    if (LoginContext.accessToken != null)
      map['Authorization'] = 'Bearer ' + LoginContext.accessToken;
    if (body) map['Content-Type'] = 'application/json';
    if (entries != null) for (MapEntry e in entries) map[e.key] = e.value;
    return map;
  }
}

extension HttpExtension on http.Response {
  bool isSuccess() {
    return this.statusCode >= 200 && this.statusCode <= 204;
  }
}