import 'package:designui/src/View/home.dart';
import 'package:designui/src/view/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        // '/': (context) => Loading(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
      },
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
