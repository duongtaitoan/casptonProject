import 'dart:io';
import 'package:designui/src/Helper/showEventDialog.dart';
import 'package:designui/src/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterEventPage extends StatefulWidget {
  final FirebaseUser uid;
  final int count;
  const RegisterEventPage({Key key, this.uid, this.count}) : super(key: key);

  @override
  _RegisterEventPageState createState() => _RegisterEventPageState(uid,count);
}

class _RegisterEventPageState extends State<RegisterEventPage> {
  final FirebaseUser uid;
  var count;
  _RegisterEventPageState(this.uid,this.count);

  var testLocation = 'Test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sự kiện'),
        backgroundColor: Colors.amberAccent[400],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        uid: uid,
                      )),
              (Route<dynamic> route) => false),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/events$count.png',
                width: double.infinity,
                height: 250,
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  'Welcome Events $count',
                  style: TextStyle(fontSize: 20.0, color: Color(0xff333333)),
                ),
              ),
              Container(
                height: 40,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 15,),
                    Expanded(
                    flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/date_time.png',
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(width: 7,),
                          // Color(Colors.blue),
                        Text("7:30 AM 3/10/2020",
                            style: TextStyle(
                                color: Colors.black, fontSize: 15.0)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/date_time.png',
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(width: 7,),
                          // Color(Colors.blue),
                          Text("9:30 AM 3/10/2020",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.0)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 6, 20, 0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.weekend),
                        Text("Số lượng người tham gia ",
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0)),
                        Text(
                          "12 ",
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.event),
                          Text("Giới thiệu sơ qua về sự kiện",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 17.0)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 200.0,
                      child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:<Widget> [
                              Text(
                                'Chủ đề sự kiện',
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),
                              ),
                              Text(
                                'Nội dung hoạt động trong sự kiện',
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),
                              ),
                              Text(
                                'Điểm nhấn mạnh trong sự kiện',
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),
                              ),
                              Text(
                                'Kết thúc sự kiện',
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),
                              ),
                            ],
                          ),
                          color: Colors.grey[50]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 30, 80, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RaisedButton(
                    onPressed: () => showAlertDialog(context),
                    child: Text(
                      'Đăng kí sự kiện',
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
