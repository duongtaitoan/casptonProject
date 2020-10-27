// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:camerawesome/models/orientations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class CameraPlugin extends StatefulWidget {
//   @override
//   _CameraPluginState createState() => _CameraPluginState();
// }
//
// class _CameraPluginState extends State<CameraPlugin> with TickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     return CameraAwesome(
//         testMode: false,
//         onPermissionsResult: (bool result) { },
//         // selectDefaultSize: (List<Size> availableSizes) => Size(1920, 1080),
//     onCameraStarted: () { },
//     onOrientationChanged: (CameraOrientations newOrientation) { },
//     sensor: _sensor,
//     photoSize: _photoSize,
//     switchFlashMode: _switchFlash,
//     orientation: DeviceOrientation.portraitUp,
//     fitted: true,
//     );
//   }
//
//
//   ValueNotifier<CameraFlashes> _switchFlash = ValueNotifier(CameraFlashes.NONE);
//   ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);
//   ValueNotifier<Size> _photoSize = ValueNotifier(null);
//
//   // Controller
//   PictureController _pictureController = new PictureController();
//
//   // await _pictureController.takePicture('THE_IMAGE_PATH/myimage.jpg');
// }