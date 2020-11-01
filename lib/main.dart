import 'dart:io';

import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/view/login.dart';
import 'package:flutter/material.dart';

void main(){
  // if error is pass
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G&I',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:SafeArea(
        child: SizedBox.expand(
          child: LoginPage(),
        ),
      ),
    );
  }
}
