import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowMessage{
  // show by toast
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

  // limit name title of event
  static functionLimitCharacter(String text){
    print('text ${text}');
    String firstHalf;
    if (text.length >= 20 && text != null) {
      firstHalf = text.substring(0, 20)+' ... ';
      return firstHalf;
    }else{
      return text;
    }
  }

  static String utf8convert(String text) {
    List<int> bytes = text.toString().codeUnits;
    return utf8.decode(bytes);
  }

  // show by dialog
  static functionShowDialog(String sms,BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: Center(child: Row(children: <Widget>[
            Text("Message"),
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