import 'package:designui/src/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SupportPage extends StatefulWidget {
  final FirebaseUser uid;
  const SupportPage({Key key, this.uid}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState(uid);
}

class _SupportPageState extends State<SupportPage> {
  final FirebaseUser uid;
  _SupportPageState(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hỗ trợ'),
        backgroundColor: Colors.amberAccent[400],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> HomePage(uid: uid,)), (Route<dynamic> route) => false),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.all(0.0),
                          child: Row(
                            children: <Widget>[
//                              Icon(
//                                Icons.menu,
//                                size: 40.0,
//                              ),
                              Text("Mục lục ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20.0),
                    child: TextFormField(
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            suffixIcon:
                            Icon(Icons.search, color: Colors.black),
                            contentPadding:
                            EdgeInsets.only(left: 15.0, top: 15.0),
                            hintText: 'danh sách hỗ trợ',
                            hintStyle: TextStyle(
                                color: Colors.black54, fontSize: 20.0)),

                        onFieldSubmitted: (String input) {}),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.all(0.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.import_contacts,
                                size: 40.0,
                              ),
                              Text(" Nội dung ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 316.0,
                      child: Card(
                          child: Container(
                            child: TextFormField(
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                    EdgeInsets.only(left: 15.0, top: 15.0),
                                    hintText: 'Nội dung cần hỗ trợ',
                                    hintStyle: TextStyle(
                                        color: Colors.black54, fontSize: 20.0)),
                                onFieldSubmitted: (String input) {}),
                          ),
                          color: Colors.green
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 37),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RaisedButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "Nội dung của bạn đã được gửi thành công",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 3,
                          fontSize: 20.0,
                          textColor: Colors.black
                      );
                    },
                    child: Text(
                      'Gửi',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    color: Colors.amberAccent[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
