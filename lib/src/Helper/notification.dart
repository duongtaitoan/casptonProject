import 'package:designui/src/View/home.dart';
import 'package:designui/src/View/registers_event.dart';
import 'package:designui/src/ViewModel/events_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationEvent{

  // notification
  void configOneSignal(uid,context) async{
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.info, OSLogLevel.none);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    //ID for onesignal
    await OneSignal.shared.init('5efe7693-153f-42df-b3c4-b3fced8029c4',iOSSettings: settings);
    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

    OneSignal.shared.consentGranted(true);
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    _handleSetExternalUserId(uid,context);
  }

  // handler external for userid
  Future<void> _handleSetExternalUserId(uid,context) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token_data");
      var decodedToken = JwtDecoder.decode(token);
      int userId = int.parse(decodedToken["sub"]);

      // set external for user id
      OneSignal.shared.setExternalUserId("${userId}");
      await OneSignal.shared.setSubscription(true);

      OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult openedResult) {
          Map<String, dynamic> data = openedResult.notification.payload.additionalData;

          var dataIdEvent = data["eventId"];
          var dataType = data["type"];
          var dataChangStatus = data["registrationStatus"];
          var dataNameLocation = data["locationDetails"];

          if(dataType == "EVENT_STATUS_CHANGED") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegisterEventPage(
                  uid: uid, idEvents: int.parse(dataIdEvent),nameLocation: dataNameLocation,)));
          }else if(dataType == "REGISTRATION_STATUS_CHANGED"){
            if(dataChangStatus == "APPROVED"){
              Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)
              => HomePage(uid: uid,barSelect:1,pageIndex:1)), (Route<dynamic> route) => false);
            }else if(dataChangStatus == "REJECTED"){
              Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)
              => HomePage(uid: uid,barSelect:1,pageIndex:2)), (Route<dynamic> route) => false);
            }else if(dataChangStatus == "CHECKED_IN"){
              Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)
              => HomePage(uid: uid,barSelect:1,pageIndex:3)), (Route<dynamic> route) => false);
            }else{
              Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)
              => HomePage(uid: uid,barSelect:1,pageIndex:0)), (Route<dynamic> route) => false);
            }
          }
        });

      OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) async {
      });
    }catch(e){
    }
  }

  Future<void> removeUserId() async {
    OneSignal.shared.removeExternalUserId();
    await OneSignal.shared.setSubscription(false);
  }

}