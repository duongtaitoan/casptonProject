import 'package:flutter/foundation.dart';

class LoginContext extends ChangeNotifier {
  static const int NOT_LOGGED_IN = 1;
  static const int LOGGED_IN = 2;
  static String accessToken;
  Map<String, dynamic> tokenData;
  int _state = NOT_LOGGED_IN;

  bool isLoggedIn() => _state == LOGGED_IN;

  bool isNotLoggedIn() => _state == NOT_LOGGED_IN;

  void loggedIn(Map<String, dynamic> tokenData) {
    LoginContext.accessToken = tokenData["access_token"] as String;
    print('TokenData :'+tokenData.toString());
    this.tokenData = tokenData;
    _state = LOGGED_IN;
    notifyListeners();
  }

  void signOut() {
    LoginContext.accessToken = null;
    this.tokenData = null;
    _state = NOT_LOGGED_IN;
    notifyListeners();
  }
}