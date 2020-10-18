import 'dart:math';

import 'file:///F:/ProjectFlutter/design_ui/design_ui/lib/src/ViewModel/login_viewmodel.dart';
import 'package:designui/src/Model/userDAO.dart';
import 'package:designui/src/View/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  LoginContext _loginContext;


  void _onSignInFinished(FirebaseUser user) async {
    if (user == null) return;
    IdTokenResult fbTokenResult = await user.getIdToken(refresh: true);
    String fbToken = fbTokenResult.token;
    var success = false;


    _signInServer(
            fbToken: fbToken,
            success: (tokenData) {
              _firebaseMessaging
                  .subscribeToTopic(tokenData["token"])
                  .catchError((e) => _loginError(err: e))
                  .then((value) {
                success = true;
                _loginContext.loggedIn(tokenData);
              }).catchError((e) => _loginError(err: e));
            },
            invalid: null,
            error: _loginError)
        .whenComplete(() {
      if (!success){ _loginError(err: e);};
    });
  }

  Future<void> _loginError({Object err}) async {
    print(err);
    await _googleSignIn.signOut();
    await _auth.signOut();
    print('Login context :'+_loginContext.tokenData.toString());
    print('get Tokent :'+UserDao.getTokenData().toString());
    var tokenData = _loginContext.tokenData ?? (await UserDao.getTokenData());
    print('222222222222ssssssssssssssssssssssssssssssssssssssssss');
    if (tokenData != null) {
      await UserDao.clearTokenData();
      await _firebaseMessaging.unsubscribeFromTopic(tokenData["token"]);
      _loginContext.signOut();
    }
  }

  Future<void> _signInServer(
      {@required String fbToken,
      Function success,
      Function invalid,
      Function error}) async {
    return await UserDao.login(
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
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

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

  void onSignInPressed() async {
    _handleSignIn()
        .then(this._onSignInFinished)
        .catchError((e) => this._loginError(err: e))
        .whenComplete(() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      RegExp regExp = RegExp("^[a-z0-9_\.]{8,}@[fpt|fu]{1,4}(\.[edu]{3})(\.[vn]{2})");
      if (user == null || !regExp.hasMatch(user.email.toString()) ){
        return Fluttertoast.showToast(
            msg: "Đăng nhập tài khoản trường \n VD:example@fpt.edu.vn",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 5,
            fontSize: 20.0,
            textColor: Colors.black);
      }
      else{
        await Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(uid: user)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
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
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          )
                        ],
                      ),
                      onPressed: () => onSignInPressed())),
            ],
          ),
        ),
      ),
    );
  }
}


