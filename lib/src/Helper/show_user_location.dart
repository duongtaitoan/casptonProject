import 'dart:async';
import 'dart:io';
import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/Model/TrackingDTO.dart';
import 'package:designui/src/View/feedback.dart';
import 'package:designui/src/ViewModel/tracking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class show {
  showLocationDiaLog(duration,idEvents,show,BuildContext context,uid,nameEvents,idStudent,timeEnd,timeDuration) async {
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

    // check minus and mode for 5
    int lastTime = timeDuration;
    print('Last Time :' + lastTime.toString());

    // get times when %
    int counts = 0;
    for (int j = 0; j < lastTime; j++) {
      if (j % 5 == 0) {
        counts++;
      }
    }
    // get location
    timeLocation(_locationData,counts,show,idEvents,context,uid,nameEvents,idStudent,duration,timeEnd);
  }

  // if status == false then get location
  static functionGetLocation() async {
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

    // get address
    final coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var addresByLocation = addresses.first;

    List tmpLocation = new List();
    tmpLocation.add(_locationData.latitude);
    tmpLocation.add(_locationData.longitude);
    tmpLocation.add(addresByLocation.addressLine);
    return tmpLocation;
  }
}

Future timeLocation(_locationData,counts,show,idEvents,BuildContext context,uid,nameEvents,idStudent,duration,timeEnd) {
  DateTime now = DateTime.now();
  return new Future.delayed(const Duration(milliseconds: 1), () async {
    Stopwatch s = new Stopwatch();
    for (int i = 0; i <= 3; i++) {
      if(now.isBefore(DateTime.parse(timeEnd))){
        sleep(const Duration(milliseconds: 1));
        await Future.delayed(new Duration(seconds: duration),() async {
          if(show == true) {
            print('---');
            // get address location by latitude and longitude
            final coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
            var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
            var first = addresses.first;
            // notification sms
            ShowMessage.functionShowMessage("Your location has been sent to APT server.");
            // send location and address to server
            sendLocation(new TrackingDTO(latitude: _locationData.latitude,longitude: _locationData.longitude,studentId:idStudent,eventId: idEvents,
                address: first.addressLine));
          }
          // if tracking requited == false => no get your location
          if(i == counts) {
            try {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      FeedBackPage(uid: uid, nameEvents: nameEvents,
                          idEvent: idEvents, screenHome: "HomePage",idStudent:idStudent)));
            }catch(e){
              ShowMessage.functionShowMessage("Can not feedback this events");
            }
          }
          // show test => done then delete
          print('counts :${i}----- >location :'+ _locationData.longitude.toString()+ " - - - "+ _locationData.latitude.toString());
          s.stop();
        });
      }else{
        s.stop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                FeedBackPage(uid: uid, nameEvents: nameEvents,
                    idEvent: idEvents, screenHome: "HomePage",idStudent:idStudent)));
      }
    }
  });
}
