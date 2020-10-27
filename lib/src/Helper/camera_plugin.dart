import 'dart:io';
import 'package:designui/src/View/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class CameraApp extends StatefulWidget {
  final FirebaseUser uid;
  final status;
  final timeStart;
  final timeStop ;
  final nameEvents;
  const CameraApp({Key key, this.uid, this.status,this.timeStart,this.timeStop,this.nameEvents}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CameraAppPageState(uid,status,timeStart,timeStop,nameEvents);
  }
}

class _CameraAppPageState extends State<CameraApp> {
  File imageFile = null;
  final FirebaseUser uid;
  final status;
  var timeStart;
  var timeStop ;
  var nameEvents;
  _CameraAppPageState(this.uid, this.status,this.timeStart,this.timeStop,this.nameEvents);

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
                  "Chụp Ảnh sự kiện",
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
                                    child: Text("Chụp Ảnh",style: TextStyle(color: Colors.white))),
                              ),
                              SizedBox(width: 20,),
                              Expanded(
                                flex: 1,
                                child: RaisedButton(
                                    color: Colors.orange[400],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                    onPressed: () {
                                      // xử lý ảnh gửi
                                      // nếu trùng với ảnh ở phía server thì get location tracking
                                      // _buttonTakePicture(context);
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
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Bạn tham gia sự kiện thành công"),
      ));
      print("Bạn chọn ảnh: " + imageFile.path);
      setState(() {
        debugPrint("Ảnh bạn chọn  $imageFile");
      });
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Ảnh bạn chụp tham gia sự kiện thất bại.\nXin vui lòng chụp lại"),
      ));
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