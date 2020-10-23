import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginContext extends ChangeNotifier {
  static String accessToken;
  String tokenData;

  Future<void> loggedIn() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    if(token != null){
      this.tokenData = token;
    }
    notifyListeners();
  }

  void signOut() {
    LoginContext.accessToken = null;
    this.tokenData = null;
    notifyListeners();
  }
}