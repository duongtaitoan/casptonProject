import 'dart:io';
import 'package:designui/src/Model/TrackingDTO.dart';
import 'package:designui/src/ViewModel/tracking_viewmodel.dart';
import 'package:location/location.dart';

class show {
  showLocationDiaLog(timeStart, timeStop,idEvents) async {
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
    // get location
    location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 1000, distanceFilter: 0);
    _locationData = await location.getLocation();

    // get position in string
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
    Stopwatch s = new Stopwatch();
      print('----------Start------------');
      for (int i = 0; i < 5; i++) {
        sleep(new Duration(seconds: 1));
        print('location :'+_locationData.longitude.toString()+ " - - - "+_locationData.latitude.toString());
        getLocation(new TrackingDTO(eventId: idEvents,longitude: _locationData.longitude,latitude: _locationData.latitude));
        s.stop();
      }
      print('-----------Stop-----------');
  }
}
