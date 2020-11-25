import 'dart:io';
import 'package:designui/src/Model/TrackingDTO.dart';
import 'package:designui/src/ViewModel/tracking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

class show {
  showLocationDiaLog(duration,idEvents) async {
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
    //set permission location
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // set time,accuracy and update minimum displacement of location
    location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 1000, distanceFilter: 0);
    _locationData = await location.getLocation();

    // check minus * 60 and mode for 5
    int lastTime = duration * 60 ;
    print('Last Time :' + lastTime.toString());

    // get times when %
    int num = 0;
    for (int j = 0; j < lastTime; j++) {
      if (j % 5 == 0) {
        num++;
      }
    }

    Stopwatch s = new Stopwatch();
      print('----------Start------------');
      for (int i = 0; i < 8; i++) {
        // set minus == 5
        sleep(new Duration(seconds: 3));
        var locationUser = "Latitude ${_locationData.latitude.toString()}\n Longtitude ${_locationData.longitude.toString()}";
        showToast(locationUser);
        print('location :'+_locationData.longitude.toString()+ " - - - "+_locationData.latitude.toString());
        // getLocation(new TrackingDTO(eventId: idEvents,longitude: _locationData.longitude,latitude: _locationData.latitude));
        s.stop();
      }
      print('-----------Stop-----------');
  }
}

// show toast
showToast(_tmpStatus){
  return  Fluttertoast.showToast(
      msg: _tmpStatus,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      fontSize: 20.0,
      textColor: Colors.black
  );
}