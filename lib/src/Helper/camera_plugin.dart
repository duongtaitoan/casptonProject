import 'dart:io';
import 'package:designui/src/Helper/show_user_location.dart';
import 'package:designui/src/Model/imageDTO.dart';
import 'package:designui/src/View/home.dart';
import 'package:designui/src/View/feedback.dart';
import 'package:designui/src/ViewModel/tracking_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class CameraApp extends StatefulWidget {
  final FirebaseUser uid;
  final status;
  final timeStart;
  final timeStop ;
  final nameEvents;
  final idEvents;
  const CameraApp({Key key, this.uid, this.status,this.timeStart,this.timeStop,this.nameEvents,this.idEvents}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CameraAppPageState(uid,status,timeStart,timeStop,nameEvents,idEvents);
  }
}

class _CameraAppPageState extends State<CameraApp> {
  File imageFile;
  final FirebaseUser uid;
  final idEvents;
  final status;
  var timeStart;
  var timeStop ;
  var nameEvents;
  _CameraAppPageState(this.uid, this.status,this.timeStart,this.timeStop,this.nameEvents,this.idEvents);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
          child:Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.orange[400],
                title: Text(
                  "Check in",
                  textAlign: TextAlign.center,
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () =>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) => HomePage(uid: uid,status: status,nameEvents: nameEvents, timeStart:timeStart,timeStop:timeStop,)),
                          (Route<dynamic> route) => false),
                ),
              ),
              body:  Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageFile == null
                                        ? AssetImage('assets/images/backgroudFPT.png')
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
                                    child: Text("Picture",style: TextStyle(color: Colors.white))),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                flex: 1,
                                child: RaisedButton(
                                    color: Colors.orange[400],
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    onPressed: () {
                                      var value = checkinEvents(new ImageDTO(eventId: idEvents,latitude: 0.0,longitude: 0.0,file: imageFile));
                                      value.then((tmpValue) async {
                                        if(tmpValue == "Checkin successful"){
                                          await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("Notification"),
                                                content: Padding(
                                                  padding: const EdgeInsets.only(left: 50),
                                                  child: Text("Your ${tmpValue}"),
                                                ),
                                              )
                                           );
                                            // get location auto
                                            var showEvents = new show();
                                            showEvents.showLocationDiaLog(timeStart, timeStop, idEvents);
                                            // if events finish then show feedback
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FeedBackPage(uid: uid,nameEvents:nameEvents)));
                                            // back home and lock this events
                                          }else{
                                           Fluttertoast.showToast(
                                              msg: tmpValue,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIos: 3,
                                              fontSize: 20.0,
                                              textColor: Colors.black);
                                          }
                                        });
                                    },
                                    child: Text("Gửi",style: TextStyle(color: Colors.white))),
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

  // image picker
  Future choiceType(BuildContext context, String pickerType) async {
    switch (pickerType) {
      case "camera":
        imageFile = await ImagePicker.pickImage(
            source: ImageSource.camera, imageQuality: 90);
        break;
    }
    if (imageFile != null) {
      print("Bạn chọn ảnh: " + imageFile.path);
      setState(() {
        debugPrint("Ảnh bạn chọn  $imageFile");
      });
    }else {
      print("Bạn không tấm ảnh nào cả");
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
              ],
            ),
          );
        });
  }
}