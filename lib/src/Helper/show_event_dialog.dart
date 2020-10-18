import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

showLocationDialog(context, timeStart, timeStop) async {
  Widget buttonYes = FlatButton(
    child: Text("Yes"),
    onPressed: () async { await
      Navigator.of(context).pop();
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
      //set permission
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      // get location
      location.changeSettings(
          accuracy: LocationAccuracy.high, interval: 1000, distanceFilter: 0);
      _locationData = await location.getLocation();

      //set date time
      DateTime now = DateTime.now();
      String checkfdt = DateFormat('HH:mm dd/MM/yyyy').format(now);
      print("formattedDate :" + checkfdt.toString());
      // get location of AM

      final endIndex = timeStart.toString().indexOf(" ");
      // cut house and minus
      List<String> cutTimeStart =
      timeStart.toString().substring(0, endIndex).toString().split(":");
      List<String> cutTimeStop =
      timeStop.toString().substring(0, endIndex).toString().split(":");
      // time future - time pass
      int resultTime = int.parse(cutTimeStop[0]) - int.parse(cutTimeStart[0]);
      int resultMinus =
          int.parse(cutTimeStop[1]) - int.parse(cutTimeStart[1]);
      // house * 60m + minus
      int result = resultTime * 60;
      int lastTime = result + resultMinus;
      print('Last Time :' + lastTime.toString());

      // get times when %
      int num = 0;
      for (int j = 0; j < lastTime; j++) {
        if (j % 5 == 0) {
          num++;
        }
      }
      // check time
      Stopwatch s = new Stopwatch();
      // check time current == time register event then start
      if (checkfdt.toString().contains(timeStart.toString())) {
        print('----------Start------------');
        for (int i = 0; i < num; i++) {
          sleep(new Duration(seconds: 1));
          print(_locationData.toString());
          s.stop();
        }
        print('-----------Stop-----------');
      }
    },
  );
  // show the dialog
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: Text("Địa chỉ người dùng"),
        content: Text("Bạn có muốn hiển thị vị trí của mình realtime"),
        actions: [
          buttonYes,
        ],
      ),
  );
}

showEventsRegisterDialog(BuildContext context) {

  // set up the AlertDialog
  AlertDialog eventsRegis = AlertDialog(
    title: Text("Sự kiện này bạn đã đăng kí "),
    content: Text("Xin vui lòng đợi admin duyệt!!"),
    actions: [
      // buttonYes,
      // buttonNo,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return eventsRegis;
    },
  );
}

showErrorDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog smsError = AlertDialog(
    title: Text("Vui lòng đợi tới ngày tham gia sự kiện"),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return smsError;
    },
  );
}
