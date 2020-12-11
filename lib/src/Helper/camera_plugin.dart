import 'dart:async';
import 'dart:io';
import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/Helper/show_user_location.dart';
import 'package:designui/src/Model/imageDTO.dart';
import 'package:designui/src/View/feedback.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uiblock/uiblock.dart';

class CameraApp extends StatefulWidget {
  final FirebaseUser uid;
  final duration ;
  final nameEvents;
  final idEvents;
  final tracking;
  final idRegister;
  final statusCheckin;
  const CameraApp({Key key, this.uid,this.duration,this.nameEvents,
    this.idEvents,this.tracking,this.idRegister,this.statusCheckin}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CameraAppPageState(uid,duration,nameEvents,idEvents,tracking,idRegister,statusCheckin);
  }
}

class _CameraAppPageState extends State<CameraApp> {
  File imageFile;
  final FirebaseUser uid;
  final tracking;
  final idRegister;
  final idEvents;
  final statusCheckin;
  var duration ;
  var nameEvents;
  var _tmpString= "assets/images/backgroudFPT.png";
  var screenHome = "HomePage";
  String _scanBarcode = 'Unknown';

  _CameraAppPageState(this.uid,this.duration,this.nameEvents,this.idEvents,this.tracking,this.idRegister,this.statusCheckin);
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
                backgroundColor: Colors.orange[400],
                title: Text("Check in", textAlign: TextAlign.center,),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) => RegisterEventPage(uid: uid,
                            idEvents: idEvents, screenHome: screenHome)),
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
                            children: <Widget>[
                              SizedBox(width: 40,),
                              Expanded(
                                flex: 1,
                                child: RaisedButton(
                                    color: Colors.orange[400],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                    onPressed: () {
                                      _buttonhandler(context);
                                    },
                                    child: Text("Type Check in",style: TextStyle(color: Colors.white))),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                flex: 1,
                                child: RaisedButton(
                                    color: Colors.orange[400],
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    onPressed: () async {
                                      // if user choice picture defaul => show messages
                                      if(imageFile == null){
                                            showdialogOfEvent("This picture is not valid");
                                      }else {
                                        var value = await checkinEvents(new ImageDTO(eventId: idEvents,latitude: 0.0,longitude: 0.0,file: imageFile));
                                        if(value == "Check in successful"){
                                          await showdialogOfEvent("Your ${value}");
                                          sendToServer(statusCheckin,idRegister);
                                        }else{
                                          ShowMessage.functionShowMessage(value);
                                        }
                                      }
                                    },
                                    child: Text("Send",style: TextStyle(color: Colors.white))),
                              ),
                              SizedBox(width: 40,),
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

  // check in image => server
  sendToServer(statuCheckin,idRegister) async {
    var _tmpMessage = await RegisterVM().updateStatusEvent(statuCheckin, idRegister,true);
    // check in events success or fail
    if(_tmpMessage == "Accept successful"){
      // requiment is tracking or not
      if(tracking == true){
        getLocationUser(tracking);
      }else{
        getLocationUser(tracking);
      }
    }else{
      ShowMessage.functionShowMessage(_tmpMessage);
    }
  }

  // when user check in success then get location of user
  getLocationUser(isTracking) async {
      Future.delayed(new Duration(microseconds: 1),()async{
          // if is tracking == true show location for user know isTracking else tracking false then not show
          await show().showLocationDiaLog(duration, idEvents,true,context,uid,nameEvents);
          // back to home screen
          final prefs = await SharedPreferences.getInstance();
          prefs.setInt("idEvent", idEvents);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePage(uid: uid)));
      });
  }

  // button take picture and scanQR
  void _buttonhandler(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new FlatButton(
                  child: Center(child: new Text('Camera',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold))),
                  onPressed: () async {
                    try{
                      // imageFile
                      imageFile = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 90);
                      Navigator.of(context).pop();
                      if (imageFile != null) {
                        print("Your picture " + imageFile.path);
                        setState(() {
                          debugPrint("$imageFile");
                        });
                      }
                    }catch(e){
                      ShowMessage.functionShowDialog("Accept permissions take a photo", context);
                    }
                  },
                ),
                new FlatButton(
                  child: Center(child: new Text('ScaneQR',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold))),
                  onPressed: () async {
                    // scan QR of event
                    try {
                      _scanBarcode = await FlutterBarcodeScanner.scanBarcode(
                          "#ff6666", "Cancel", true, ScanMode.QR);
                    } on PlatformException {
                      _scanBarcode = 'Failed to get platform version.';
                    }
                    if (!mounted) return;
                    setState(() {
                      if(_scanBarcode.compareTo(idEvents.toString()) == 0){
                        ShowMessage.functionShowMessage("Check in Success");
                        Navigator.of(context).pop();
                        sendToServer(statusCheckin,idRegister);
                      }else{
                        ShowMessage.functionShowMessage("Check in failed");
                      }
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  // showdialog for user
  showdialogOfEvent(responded) async {
    await showDialog(
      context: this.context,
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
            children:[
              Icon(Icons.notifications),
              SizedBox(width: 10,),
              Text("Notification"),
            ]
        ),
        content: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text("${responded}",style: TextStyle(fontSize: 16.0,),textAlign: TextAlign.start,),
        ),
        actions: [
          new FlatButton(
            child: const Text("Close",style: TextStyle(color: Colors.blue),),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}