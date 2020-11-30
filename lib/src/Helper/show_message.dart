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
}