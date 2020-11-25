import 'dart:async';
import 'dart:io';
import 'package:designui/src/Helper/show_user_location.dart';
import 'package:designui/src/Model/imageDTO.dart';
import 'package:designui/src/View/feedback.dart';
import 'package:designui/src/View/registers_event.dart';
import 'package:designui/src/ViewModel/tracking_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uiblock/uiblock.dart';

class CameraApp extends StatefulWidget {
  final FirebaseUser uid;
  final duration ;
  final nameEvents;
  final idEvents;
  final tracking;
  const CameraApp({Key key, this.uid,this.duration,this.nameEvents,this.idEvents,this.tracking}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CameraAppPageState(uid,duration,nameEvents,idEvents,tracking);
  }
}

class _CameraAppPageState extends State<CameraApp> {
  File imageFile;
  final FirebaseUser uid;
  final tracking;
  final idEvents;
  var duration ;
  var nameEvents;
  var _tmpString= "assets/images/backgroudFPT.png";

  String _scanBarcode = 'Unknown';
  _CameraAppPageState(this.uid,this.duration,this.nameEvents,this.idEvents,this.tracking);
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
                title: Text(
                  "Check in",
                  textAlign: TextAlign.center,
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () =>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) => RegisterEventPage(uid: uid,idEvents: idEvents,)),
                          (Route<dynamic> route) => false),
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
                      SizedBox(
                        height: 10.0,
                      ),
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
                                      _buttonTakePicture(context);
                                    },
                                    child: Text("Type Check in",style: TextStyle(color: Colors.white))),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                flex: 1,
                                child: RaisedButton(
                                    color: Colors.orange[400],
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    onPressed: () {
                                    // if user choice picture defaul => showdialog
                                      if(imageFile == null){
                                            showdialogOfEvent("This picture is not valid");
                                      }else {
                                        sendToServer();
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
  sendToServer() async {
    var checkin = false;
    // check in events success or fail
    var value = await checkinEvents(new ImageDTO(eventId: idEvents,latitude: 0.0,longitude: 0.0,file: imageFile));
    if(value == "Check in successful"){
      await showdialogOfEvent("Your ${value}");
      // if event requirements check in by location => get location of user
      if(tracking == true){
        checkin = true;
        blockUIChecIn(checkin);
      }else{
        checkin = false;
        blockUIChecIn(checkin);
      }
      // if events finish then show feedback
    }else{
      // show status check in then fail
      showToast(value);
    }
  }

  // block screen check in
  blockUIChecIn(checkin) {
    // back events details
    Navigator.of(_scaffoldGlobalKey.currentContext).push(MaterialPageRoute(
          builder: (context) => RegisterEventPage(uid: uid, nameEvents: nameEvents,
                  idEvents: idEvents, scaffoldGlobalKey: _scaffoldGlobalKey)),
    );
    // lock screen and do not for user click ...
    UIBlock.block(
      _scaffoldGlobalKey.currentContext,
      loadingTextWidget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Please wait for the event to end and do not turn off the app',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    Future.delayed(Duration(seconds: 1), (){
      if (checkin == false) {
        // time block screen set time to delayed when events not get location
        // var _tmpTime = duration*60;
        Future.delayed(new Duration(microseconds: 1),()async{
            await show().showLocationDiaLog(duration, idEvents);
        });
            // get location
        Future.delayed(
          Duration(seconds: 10), () async {
            // unblock
            UIBlock.unblock(_scaffoldGlobalKey.currentContext);
            // go to feedback
            // Navigator.of(_scaffoldGlobalKey.currentContext).push(MaterialPageRoute(builder: (context)=>FeedBackPage(uid: uid,nameEvents:nameEvents)));
          },
        );
      } else {
        Future.delayed(
            Duration(seconds: 1), () async {
            await show().showLocationDiaLog(duration, idEvents);
            UIBlock.unblock(_scaffoldGlobalKey.currentContext);
            // Navigator.of(_scaffoldGlobalKey.currentContext).push(MaterialPageRoute(builder: (context)=>FeedBackPage(uid: uid,nameEvents:nameEvents)));
        });
      }
    });
  }

  // image picker
  Future choiceType(BuildContext context, String pickerType) async {
    try {
    switch (pickerType) {
      case "camera":
        imageFile = await ImagePicker.pickImage(
            source: ImageSource.camera, imageQuality: 90);
        break;
      case "scaneQR":
        scanQR();
        break;
    }
      if (imageFile != null) {
        print("Bạn chọn ảnh: " + imageFile.path);
        setState(() {
          debugPrint("Ảnh bạn chọn  $imageFile");
        });
      }
    }on PlatformException {
       return 'Failed to get platform version.';
    }
  }

  // Image picker
  void _buttonTakePicture(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  title: Center(child: new Text('Camera',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold))),
                  onTap: () => {
                    choiceType(context, "camera"),
                    Navigator.pop(context)
                  },
                ),
                new ListTile(
                  title: Center(child: new Text('scaneQR',style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold))),
                  onTap: () => {
                    choiceType(context, "scaneQR"),
                    Navigator.pop(context)
                  },
                ),
              ],
            ),
          );
        });
  }

  // scan QR of event
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // show status check in event
  showToast(responded){
    Fluttertoast.showToast(
        msg: responded,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        fontSize: 20.0,
        textColor: Colors.black);
  }

  // showdialog for user
  showdialogOfEvent(responded) async {
    await showDialog(
      context: this.context,
      child: AlertDialog(
        title: Text("Notification"),
        content: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text("${responded}",style: TextStyle(fontSize: 16.0,),textAlign: TextAlign.start,),
        ),
        actions: [
          new FlatButton(
            child: const Text("Close",style: TextStyle(color: Colors.red),),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}