import 'dart:io';

import 'package:designui/src/Helper/notification.dart';
import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/Model/user_profileDAO.dart';
import 'package:designui/src/view/login.dart';
import 'package:designui/src/view/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeMenu extends StatefulWidget {
  final FirebaseUser uid;

  const HomeMenu({Key key, this.uid}) : super(key: key);
  @override
  _HomeMenuState createState() => _HomeMenuState(uid);
}

class _HomeMenuState extends State<HomeMenu> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseUser uid;
  // var status;
  _HomeMenuState(this.uid);

  @override
  Widget build(BuildContext context) {
    var userName = uid.displayName;
    var account = uid.photoUrl;
    return SafeArea(
      child:SizedBox.expand(
        child: ListView(
          children: <Widget>[
            // name and icone user
            Column(
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(80, 10, 80, 0),
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.network(account,width: 120,height: 120,fit: BoxFit.cover,),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Expanded(
                  flex: 0,
                  child: Center(
                    child: Text("$userName",
                      style: TextStyle(fontSize: 25, color: Color(0xff323643)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Center(
              child: Text('_______________________________________',style: TextStyle(color: Colors.black),),
            ),
            SizedBox(height: 30,),
            // user profile
            handlerItemMenu(
              'assets/images/acc.png',
              'Personal Information',
              UserProfilePage(uid: uid)
            ),
            SizedBox(height: 10,),
            // delete my account
            handlerDelete(),
            SizedBox(height: 10,),
            // logout
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox( width: 25,),
                    Expanded(
                      flex: 5,
                      child: ListTile(
                        leading: Image.asset("assets/images/logout.png",width: 30,height: 30,),
                        title: Text("Logout", style: TextStyle(fontSize: 18, color: Color(0xff323643)),),
                        onTap: () async {
                          googleSignIn.signOut();
                          _auth.signOut();
                          await NotificationEvent().removeUserId();
                          SharedPreferences sp = await SharedPreferences.getInstance();
                          await sp.clear();
                          File("/data/data/com.ben.apt/shared_prefs/OneSignal.xml").delete(recursive: true);
                          // back to login and when user click button back => logout app
                          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>LoginPage()), (Route<dynamic> route) => false);
                          ShowMessage.functionShowMessage("Logout successful");
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        )
      )
    );
  }


  Widget handlerItemMenu(String img,String nameTitle, pushButton){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox( width: 25,),
            Expanded(
              flex: 5,
              child: ListTile(
                leading: Image.asset('${img}',width: 30,height: 30),
                title: Text(nameTitle,style: TextStyle(fontSize: 18, color: Color(0xff323643))),
                onTap: () {
                  // go to screen
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>pushButton));
                },
              ),
            ),
          ],
        )
      ],
    );
  }


  Widget handlerDelete(){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox( width: 25,),
            Expanded(
              flex: 5,
              child: ListTile(
                leading: Image.asset('assets/images/deleteAccount.png',width: 30,height: 30),
                title: Text("Delete my account",style: TextStyle(fontSize: 18, color: Color(0xff323643))),
                onTap: ()async {
                  // go to screen

                  await showDialog(
                    context: this.context,
                    child: AlertDialog(
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            SizedBox(width: 10,),
                            Text("Message"),
                          ]
                      ),
                      content: Text("Delete my account?",style: TextStyle(fontSize: 16.0,),textAlign: TextAlign.center,),
                      actions: [
                        new FlatButton(
                          child: Text("Yes",style: TextStyle(color: Colors.blue[500]),),
                          onPressed: () async {
                             await UserProfileDAO().deleteMyAccount();
                             // logout
                             googleSignIn.signOut();
                             _auth.signOut();
                             // remove External UserId()
                             await NotificationEvent().removeUserId();
                             // clear shared preferences
                             SharedPreferences sp = await SharedPreferences.getInstance();
                             sp.clear();
                             // back to login and when user click button back => logout app
                             Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>LoginPage()), (Route<dynamic> route) => false);
                             ShowMessage.functionShowMessage("Logout successful");
                          },
                        ),
                        new FlatButton(
                          child: Text("No",style: TextStyle(color: Colors.blue[500]),),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}