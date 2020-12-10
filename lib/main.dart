import 'dart:io';

import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/View/home.dart';
import 'package:designui/src/view/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // if error is pass
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  DateFormat sqlDF = DateFormat('yyyy-MM-ddTHH:mm:ss');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G&I',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: SizedBox.expand(
          child: authorization(),
        ),
      ),
    );
  }

  Widget authorization() {
    var now;
    DateTime finishTime;
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data != null) {
            String token = snapshot.data.getString("token_data");
            try {
              String timeFrom = snapshot.data.getString("timeFrom");
              finishTime = sqlDF.parse(timeFrom);
              now = DateTime.now();
            }catch(e){
              return LoginPage();
            }
            if (token != null) {
              return FutureBuilder<FirebaseUser>(
                future: FirebaseAuth.instance.currentUser(),
                builder: (BuildContext context,
                    AsyncSnapshot<FirebaseUser> snapshot) {
                  if (snapshot.hasData) {
                    var user = snapshot
                        .data; // this returns you logged firebase user
                    return HomePage(uid: user);
                  }
                  return CircularProgressIndicator();
                },
              );
              //if(now.isBefore(finishTime))
            } else if (now.isBefore(finishTime)) {
              return LoginPage();
            }
          }
        }
        return CircularProgressIndicator();
      },
    );
  }

}
