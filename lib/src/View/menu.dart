import 'package:designui/src/view/history.dart';
import 'package:designui/src/view/login.dart';
import 'package:designui/src/view/support.dart';
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
            // profile
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox( width: 25,),
                    Expanded(
                      flex: 5,
                      child: ListTile(
                        leading: Image.asset("assets/images/acc.png",width: 30,height: 30),
                        title: Text("Thông tin cá nhân", style: TextStyle(fontSize: 18, color: Color(0xff323643)),),
                        onTap: () {
                          // back to login and when user click button back => logout app
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserProfilePage(uid: uid)));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 10,),
            // history
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox( width: 25,),
                    Expanded(
                      flex: 5,
                      child: ListTile(
                        leading: Image.asset("assets/images/history.png",width: 30,height: 30),
                        title: Text("Lịch sử", style: TextStyle(fontSize: 18, color: Color(0xff323643)),),
                        onTap: () {
                          // back to login and when user click button back => logout app
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HistoryPage(uid: uid)));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 10,),
            // support
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox( width: 25,),
                    Expanded(
                      flex: 5,
                      child: ListTile(
                        leading: Image.asset("assets/images/help.png",width: 30,height: 30),
                        title: Text("Giúp đỡ", style: TextStyle(fontSize: 18, color: Color(0xff323643)),),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SupportPage(uid: uid)));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
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
                        title: Text("Thoát", style: TextStyle(fontSize: 18, color: Color(0xff323643)),),
                        onTap: () async {
                          googleSignIn.signOut();
                          _auth.signOut();
                          SharedPreferences sp = await SharedPreferences.getInstance();
                          sp.remove("token_data");
                          // back to login and when user click button back => logout app
                          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>LoginPage()), (Route<dynamic> route) => false);
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
}