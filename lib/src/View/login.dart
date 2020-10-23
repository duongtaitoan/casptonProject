import 'dart:io';

import 'package:designui/src/Service/google_sign.dart';
import 'package:designui/src/View/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void onSignInPressed() async {
    FirebaseUser user = await GoogleSign.handleSignIn();
    String status = await GoogleSign.onSignInFinished(user);
    RegExp regExp =
        RegExp("^[a-z0-9_\.]{8,}@[fpt|fu]{1,4}(\.[edu]{3})(\.[vn]{2})");
    if (status != "Đăng nhập thành công" ||
        !regExp.hasMatch(user.email.toString())) {
      Fluttertoast.showToast(
          msg: status,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 24.0,
          textColor: Colors.black);
    } else {
      await Padding(
          padding: const EdgeInsets.all(10.0),
          // loading when not found
          child: Column(
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              ),
              await Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomePage(
                        uid: user,status: status,
                      ))),
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
          child: Scaffold(
            body: Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/backgroud6.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 215,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Events Tracking",style: TextStyle(color: Colors.orange,fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Image.asset('assets/images/logoFPTU.png',
                        width: 200, height: 150),
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
                                Icon(Icons.email,color: Colors.orange,),
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
                            onPressed: () async {
                              await onSignInPressed();
                            })),
                  ],
                ),
              ),
            ),
          ),
      )
    );
  }
}
