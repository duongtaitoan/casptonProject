import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/Service/google_sign.dart';
import 'package:designui/src/View/home.dart';
import 'package:designui/src/View/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uiblock/uiblock.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var imgBackGroud = AssetImage('assets/images/backgroud6.png');
  GlobalKey _scaffoldGlobalKey = GlobalKey();
  bool showLoader = false;
  var _tmpStatus = "You need to update information";
  @override
  void initState() {
    super.initState();
  }

  void onSignInPressed() async {
      FirebaseUser user = await GoogleSign.handleSignIn();
      String status = await GoogleSign.onSignInFinished(user);
      RegExp regExp = RegExp("^[a-z0-9_\.]{8,}@[fpt|fu]{1,4}(\.[edu]{3})(\.[vn]{2})");
      if (!regExp.hasMatch(user.email.toString())) {
        try{
          ShowMessage.functionShowMessage(status);
        }catch(e){
      }
      } else if(status == "Signin successful") {
        Padding(
            padding: const EdgeInsets.all(10.0),
            // loading when not found
            child: Column(
              children: <Widget>[
                Center (
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage("assets/images/tenor.gif"),width: 300,height: 300,),
                    ],
                  ),
                ),
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
                Center (
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage("assets/images/tenor.gif"),width: 300,height: 300,),
                    ],
                  ),
                ),
                await Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => UserProfilePage(uid: user,status:_tmpStatus),),
                ),
              ],
            ));
      }else{
        ShowMessage.functionShowMessage("Connecting server error");
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
                  image: imgBackGroud,
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 215,),
                    Center(
                      child:Text("Events Tracking",style: TextStyle(color: Colors.orange,fontSize: 35, fontWeight: FontWeight.bold),),
                    ),
                    Image.asset('assets/images/logoFPTU.png',
                        width: 200, height: 140),
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
                                Text('Sign in with Gmail',
                                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                                )
                              ],
                            ),
                            onPressed: () async {
                              try{
                                UIBlock.block(_scaffoldGlobalKey.currentContext);
                                await Future.delayed(Duration(microseconds: 1), () async => {
                                  await onSignInPressed(),
                                });
                                UIBlock.unblock(_scaffoldGlobalKey.currentContext);
                              } on PlatformException catch(_) {
                                  UIBlock.unblock(_scaffoldGlobalKey.currentContext);
                                  ShowMessage.functionShowDialog("Your network is fail",context);
                              } catch(e){
                                  if(e.toString().contains("null")){
                                    UIBlock.unblock(_scaffoldGlobalKey.currentContext);
                                    ShowMessage.functionShowDialog("Not fount your account", context);
                                  }else {
                                    UIBlock.unblock(_scaffoldGlobalKey.currentContext);
                                    ShowMessage.functionShowDialog("Server error", context);
                                  }
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
