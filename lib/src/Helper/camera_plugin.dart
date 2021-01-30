import 'dart:async';
import 'dart:io';
import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/Helper/show_user_location.dart';
import 'package:designui/src/Model/imageDTO.dart';
import 'package:designui/src/View/home.dart';
import 'package:designui/src/View/registers_event.dart';
import 'package:designui/src/ViewModel/register_viewmodel.dart';
import 'package:designui/src/ViewModel/tracking_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uiblock/uiblock.dart';

class CameraApp extends StatefulWidget {
  final FirebaseUser uid;
  final duration ;
  final nameEvents;
  final idEvents;
  final tracking;
  final idRegister;
  final nameLocation;
  final statusCheckin;
  final checkInQrCode;
  final timeEnd;
  final timeDuration;
  const CameraApp({Key key, this.uid,this.duration,this.nameEvents,this.timeEnd,this.timeDuration,
    this.idEvents,this.tracking,this.idRegister,this.statusCheckin,this.checkInQrCode,this.nameLocation}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CameraAppPageState(uid,duration,nameEvents,idEvents,tracking,idRegister,statusCheckin,checkInQrCode,nameLocation,timeEnd,timeDuration);
  }
}

class _CameraAppPageState extends State<CameraApp> {
  File imageFile;
  final FirebaseUser uid;
  final tracking;
  final idRegister;
  final timeEnd;
  final timeDuration;
  final nameLocation;
  final idEvents;
  final checkInQrCode;
  final statusCheckin;
  var duration ;
  var nameEvents;
  var _tmpString= "assets/images/backgroudFPT.png";
  var screenHome = "HomePage";
  String _scanBarcode = 'Unknown';
  var _tmpCheckin = false;


  _CameraAppPageState(this.uid,this.duration,this.nameEvents,this.idEvents,this.tracking,this.idRegister,this.statusCheckin,
      this.checkInQrCode,this.nameLocation,this.timeEnd,this.timeDuration);
  GlobalKey _scaffoldGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
          child:Scaffold(
            key: _scaffoldGlobalKey,
              appBar: AppBar(
                backgroundColor: Colors.orange[600],
                title: Text("Check in", textAlign: TextAlign.center,),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) => RegisterEventPage(uid: uid,
                            idEvents: idEvents, screenHome: screenHome,nameLocation: nameLocation,)),
                            (Route<dynamic> route) => false);
                  }
                ),
              ),
              body:  Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: Container(
                            width: MediaQuery.of(context).size.width ,
                            height: MediaQuery.of(context).size.height ,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageFile == null
                                        ? AssetImage('${_tmpString}')
                                        : FileImage(imageFile),
                                    fit: BoxFit.cover))),
                      ),
                      SizedBox(height: 10.0,),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 70,),
                              Expanded(
                                flex: 1,
                                child: RaisedButton(
                                    color: Colors.orange[600],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                    onPressed: () async {
                                      try {
                                        _scanBarcode = await FlutterBarcodeScanner.scanBarcode(
                                            "#ff6666", "Cancel", true, ScanMode.QR);
                                      } on PlatformException {
                                        _scanBarcode = 'Failed to get platform version.';
                                      }
                                      if (!mounted) return;
                                      try{
                                        var tmpLocation = await show.functionGetLocation();
                                        var checkinFirst = await sendLocationFirst(tmpLocation[0],tmpLocation[1],tmpLocation[2],_scanBarcode,idEvents);
                                        // if(checkinFirst.toString().compareTo("Your registration has not been approved.") !=0 ) {
                                        if(checkinFirst.toString().compareTo("") ==0 ) {
                                          await ShowMessage.functionShowDialog(
                                              "Check in Success", context);
                                          await getLocationUser(tracking);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage(uid: uid)));
                                          setState(() {});
                                        }else{
                                            await ShowMessage.functionShowDialog("${checkinFirst}",context);
                                        }
                                      }catch(e){
                                        ShowMessage.functionShowMessage("Need to access the users camera permission.");
                                      }
                                    },
                                    child: Text("Check in by QR code",style: TextStyle(color: Colors.white))),
                              ),

                              SizedBox(width: 70,),
                              // Expanded(
                              //   flex: 1,
                              //   child: RaisedButton(
                              //       color: Colors.orange[400],
                              //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              //       onPressed: () async {
                              //         // if user choice picture defaul => show messages
                              //         if(imageFile == null){
                              //               ShowMessage.functionShowDialog("This picture is not valid",context);
                              //         }else {
                              //           //get location
                              //           var tmpLocation = await show.functionGetLocation();
                              //           // block user when send img
                              //           UIBlock.block(_scaffoldGlobalKey.currentContext,
                              //             customLoaderChild: Padding(
                              //               padding: const EdgeInsets.all(8.0),
                              //               child: Center(
                              //                 child: Column(
                              //                   mainAxisAlignment: MainAxisAlignment.center,
                              //                   children: <Widget>[
                              //                     Center (
                              //                       child: Column(
                              //                         mainAxisAlignment: MainAxisAlignment.center,
                              //                         children: <Widget>[
                              //                           Image(image: AssetImage("assets/images/tenor.gif"),width: double.infinity,height: 300,),
                              //                         ],
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ),
                              //           );
                              //
                              //           // loading status
                              //           await handlerLoading(tmpLocation);
                              //         }
                              //       },
                              //       child: Text("Send",style: TextStyle(color: Colors.white))
                              //   ),
                              // ),
                              // SizedBox(width: 30,),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
        )
    );
  }

  // handlerLoading(tmpLocation) async{
  //   var value = await checkinEvents(new ImageDTO(eventId: idEvents,
  //       latitude: tmpLocation[0],longitude: tmpLocation[1],file: imageFile));
  //     if(value != null){
  //       _tmpCheckin = true;
  //       if(value == "Check in successful"){
  //           await ShowMessage.functionShowDialog("Your ${value}",context);
  //           // await sendToServer(statusCheckin,idRegister,false);
  //         }else{
  //           await ShowMessage.functionShowDialog("${value}",context);
  //         }
  //     }
  // }

  // change status checkin == false => true server

  // sendToServer() async {
    // var _tmpMessage = await RegisterVM().updateStatusEvent(idRegister);
    // check in events success or fail
    // if(_tmpMessage == "success"){
      // requiment is tracking or not
      // if(tmpStatus == false) {
      //   UIBlock.unblock(_scaffoldGlobalKey.currentContext);
      // }
      // getLocationUser(tracking);
    // }else{
    //   UIBlock.unblock(_scaffoldGlobalKey.currentContext);
    //   await ShowMessage.functionShowMessage(_tmpMessage);
    // }
  // }

  // when user check in success then get location of user
  getLocationUser(isTracking) async {
    Future.delayed(new Duration(microseconds: 1),()async{
      // if is tracking == true show location for user know isTracking else tracking false then not show
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token_data");
      var decodedToken= JwtDecoder.decode(token);
      var idStudent = int.parse(decodedToken["sub"]);
      await show().showLocationDiaLog(duration, idEvents, isTracking, context, uid, nameEvents, idStudent,timeEnd,timeDuration);
      // back to home screen
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt("thisEventCheckin", idEvents);
    });
  }

  // button take picture and scanQR
  // void _buttonhandler(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return Container(
  //           child: new Wrap(
  //             children: <Widget>[
  //               // new FlatButton(
  //               //   child: Center(child: new Text('Camera',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold))),
  //               //   onPressed: () async {
  //               //     try{
  //               //       // imageFile
  //               //       imageFile = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 90);
  //               //       Navigator.of(context).pop();
  //               //       if (imageFile != null) {
  //               //         print("Your picture " + imageFile.path);
  //               //         setState(() {
  //               //           debugPrint("$imageFile");
  //               //         });
  //               //       }
  //               //     }catch(e){
  //               //       ShowMessage.functionShowDialog("Accept permissions take a photo", context);
  //               //     }
  //               //   },
  //               // ),
  //               new FlatButton(
  //                 child: Center(child: new Text('ScaneQR',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold))),
  //                 onPressed: () async {
  //                   // scan QR of event
  //                   try {
  //                     _scanBarcode = await FlutterBarcodeScanner.scanBarcode(
  //                         "#ff6666", "Cancel", true, ScanMode.QR);
  //                   } on PlatformException {
  //                     _scanBarcode = 'Failed to get platform version.';
  //                   }
  //                   if (!mounted) return;
  //                   if(_scanBarcode.compareTo(checkInQrCode.toString()) == 0){
  //                       await ShowMessage.functionShowDialog("Check in Success",context);
  //                       await sendToServer();
  //                     }else{
  //                       await ShowMessage.functionShowDialog("Invalid QR code",context);
  //                     }
  //                   setState(() {
  //                   });
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

}