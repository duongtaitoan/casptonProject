import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowMessage{
  static functionShowMessage(String sms){
    Future.delayed(Duration(microseconds: 500),()async{
      Fluttertoast.showToast(
      msg: sms,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 3,
      fontSize: 24.0,
      textColor: Colors.black);
    });
  }

  static functionShowDialog(String sms,BuildContext context){
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: Center(child: Row(children: <Widget>[
            Image.asset("assets/images/bell.gif",height: 50,width: 50),
            SizedBox(width: 7,),
            Text("Notification"),
          ],)),
          content: new Text("${sms}",),
          actions: <Widget>[
            FlatButton(
              child: Text('Close',style: TextStyle(color: Colors.blueAccent[500]),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }
}