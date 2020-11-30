import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ShowNotifications{
  static Future showNotificationWithDefaultSound(String title, String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id', 'channel_name', 'channel_description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await FlutterLocalNotificationsPlugin().show(
      0,
      '$title',
      '$message',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

}