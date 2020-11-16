import 'package:designui/src/Service/google_sign.dart';
import 'package:designui/src/View/home.dart';
import 'package:designui/src/View/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uiblock/uiblock.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey _scaffoldGlobalKey = GlobalKey();
  bool showLoader = false;

  void onSignInPressed() async {
      FirebaseUser user = await GoogleSign.handleSignIn();
      String status = await GoogleSign.onSignInFinished(user);
      RegExp regExp = RegExp("^[a-z0-9_\.]{8,}@[fpt|fu]{1,4}(\.[edu]{3})(\.[vn]{2})");

    if (status != "Signin successful" || !regExp.hasMatch(user.email.toString())) {
        Fluttertoast.showToast(
            msg: status,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            fontSize: 24.0,
            textColor: Colors.black);
      } else if(status == "Signin successful") {
         Padding(
            padding: const EdgeInsets.all(10.0),
            // loading when not found
            child: Column(
              children: <Widget>[
                Center(child: CircularProgressIndicator(),),
                await Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomePage(uid: user, status: status,),),
                ),
              ],
            ));
      } else if(status == "Need Information") {
        Padding(
            padding: const EdgeInsets.all(10.0),
            // loading when not found
            child: Column(
              children: <Widget>[
                Center(child: CircularProgressIndicator(),),
                await Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => UserProfilePage(uid: user,),),
                ),
              ],
            ));
      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
          child: Scaffold(
            key: _scaffoldGlobalKey,
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
                    SizedBox(height: 215,),
                    Center(
                        child:Text(
                          "Events Tracking",style: TextStyle(color: Colors.orange,fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                    ),
                    Image.asset('assets/images/logoFPTU.png',
                        width: 200, height: 140),
                    // image login by gmail
                    Container(
                        width: 200,
                        height: 50,
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
                              try{
                                UIBlock.block(_scaffoldGlobalKey.currentContext);
                                await Future.delayed(Duration(seconds: 1), () => '1');
                                await onSignInPressed();
                                UIBlock.unblock(_scaffoldGlobalKey.currentContext);
                              }catch(e){
                                UIBlock.unblock(_scaffoldGlobalKey.currentContext);
                                Fluttertoast.showToast(
                                    msg: "Please check your wifi",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    fontSize: 24.0,
                                    textColor: Colors.black);
                              }

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
