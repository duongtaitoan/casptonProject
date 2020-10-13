import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

showAlertDialog(BuildContext context) {

  Widget buttonYes = FlatButton(
    child: Text("Yes"),
    onPressed: () async {
      Navigator.of(context, rootNavigator: true).pop(true);
      Location location = new Location();
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      location.changeSettings(accuracy: LocationAccuracy.high,interval: 1000,distanceFilter: 0);
      _locationData = await location.getLocation();

      Stopwatch s = new Stopwatch();
      print('----------Start------------');
      for (int i = 0; i < 10; i++) {
        sleep(new Duration(seconds: 1));
        print(_locationData.toString());
      }
      s.stop();
      print('-----------Stop-----------');
    },
  );
  Widget buttonNo = FlatButton(
    child: Text("No"),
    onPressed: () async {
      Navigator.of(context, rootNavigator: true).pop(true);
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      Stopwatch s = new Stopwatch();
      print('----------Start------------');
      for (int i = 0; i < 10; i++) {
        sleep(new Duration(minutes: 1));
        print(_locationData.toString());
      }
      s.stop();
      print('-----------Stop-----------');

//                      location.onLocationChanged.listen((LocationData currentLocation) {
//                        testLocation = currentLocation.toString();
//                        print(testLocation.toString());
//
//                      });
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Địa chỉ người dùng"),
    content: Text("Bạn có muốn hiển thị vị trí của mình realtime"),
    actions: [
      buttonYes,
      // buttonNo,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
