import 'dart:convert';

import 'package:designui/src/Service/LoginAuthen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class LoginFirebasePage extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  LoginContext _loginContext;

  void _onSignInFinished(FirebaseUser user) async {
    if (user == null) return;
    IdTokenResult fbTokenResult = await user.getIdToken(refresh: true);
    String fbToken = fbTokenResult.token;
    print(fbToken);
    var success = false;
    _signInServer(
        fbToken: fbToken,
        success: (tokenData) {
          _firebaseMessaging
              .subscribeToTopic(tokenData["user_id"])
              .catchError((e) => _loginError(err: e))
              .then((value) {
            success = true;
            _loginContext.loggedIn(tokenData);
          }).catchError((e) => _loginError(err: e));
        },
        invalid: null,
        error: _loginError)
        .whenComplete(() {
      if (!success) Toast.LENGTH_SHORT;
    });
  }

  Future<void> _loginError({Object err}) async {
    print(err);
    await _googleSignIn.signOut();
    await _auth.signOut();
    var tokenData = _loginContext.tokenData ?? (await getTokenData());
    if (tokenData != null) {
      await clearTokenData();
      await _firebaseMessaging.unsubscribeFromTopic(tokenData["user_id"]);
      _loginContext.signOut();
    }
  }

  Future<void> _signInServer(
      {@required String fbToken,
        Function success,
        Function invalid,
        Function error}) async {
    return await login(
        invalidEmail: _handleInvalidEmail,
        success: success,
        fbToken: fbToken,
        invalid: invalid,
        error: error);
  }

  Future<void> _handleInvalidEmail() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    // this.showInvalidMessages(["Only @fpt.edu.vn is allowed"]);
  }

  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication authentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    return user;
  }

  void onSignInPressed() {
    _handleSignIn()
        .then(this._onSignInFinished)
        .catchError((e) => this._loginError(err: e));
  }

  static Future<dynamic> getTokenData() async {
    var prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> tokenData;
    var tokenDataStr = prefs.getString("token_data");
    if (tokenDataStr != null) {
      tokenData = jsonDecode(tokenDataStr);
    }
    return tokenData;
  }
  static Future<void> clearTokenData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token_data");
  }

  static Future<void> login(
      {@required String fbToken,
        Function(Map<String, dynamic> tokenData) success,
        Function(List<String> mess) invalid,
        Function() invalidEmail,
        Function error}) async {
    print('111111111111111111');
    var response = await loginAPI(fbToken: fbToken);
    print('22222222222222');
    if (response == 200) {
      print('Response body: ${response.body}');
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("token_data", response.body);
      var tokenData = jsonDecode(response.body);
      if (success != null) success(tokenData);
      return;
    } else if (response.statusCode == 400) {
      var result = jsonDecode(response.body);
      print(result);
      var validationData = result["data"]["results"];
      var mess = <String>[];
      for (dynamic o in validationData) mess.add(o["message"] as String);
      if (invalid != null) invalid(mess);
      return;
    } else if (response.statusCode == 401) {
      if (invalidEmail != null) invalidEmail();
      return;
    }
    print(response.body);
    if (error != null) error();
  }

  static Future<http.Response> loginAPI({@required String fbToken}) async {
    var uri = Uri.http("https://jsonplaceholder.typicode.com", "/users");

    var response = await http.post(uri,
        body: jsonEncode({
          "grant_type": "firebase_token",
          "firebase_token": fbToken,
        }));
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
//        color: Colors.white,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroudFPT.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 180,
              ),
              Image.asset('assets/images/logoFPTU.png',
                  width: 200, height: 150),
              SizedBox(
                height: 50,
              ),
              // image login by gmail
              Container(
                  width: 200,
                  height: 60,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    color: Color(0xffffffff),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.email),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Sign in with Gmail',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        )
                      ],
                    ),

                    onPressed: () => onSignInPressed()
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
