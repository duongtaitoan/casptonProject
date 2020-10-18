import 'package:designui/src/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterEventPage extends StatefulWidget {
  final FirebaseUser uid;
  final int count;

  const RegisterEventPage({Key key, this.uid, this.count}) : super(key: key);

  @override
  _RegisterEventPageState createState() => _RegisterEventPageState(uid, count);
}

class _RegisterEventPageState extends State<RegisterEventPage> {
  final FirebaseUser uid;
  var count;
  var timeStart = "00:17 16/10/2020";
  var timeStop = "03:17 16/10/2020";
  var valueChange = 2;
  _RegisterEventPageState(this.uid, this.count);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
      child: Scaffold(
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
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/events$count.png',
                width: MediaQuery.of(context).size.width,
                height: 180,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  'Welcome Events $count',
                  style: TextStyle(fontSize: 18.0, color: Color(0xff333333)),
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(
                        flex: 5,
                        fit: FlexFit.tight,
                        child: Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/date_time.png',
                                width: 19,
                                height: 19,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              // Color(Colors.blue),
                              Text("$timeStart",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0)),
                            ],
                          ),
                        )),
                    SizedBox(
                      width: 4,
                    ),
                    Flexible(
                        flex: 5,
                        fit: FlexFit.tight,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/date_time.png',
                                width: 19,
                                height: 19,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              // Color(Colors.blue),
                              Text("$timeStop",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Flexible(
                flex: 6,
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 20, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.weekend),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Số lượng người tham gia ",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 17.0)),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "12 ",
                            style:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.event),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Giới thiệu sơ qua về sự kiện",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 240.0,
                          child: Card(
                              borderOnForeground: true,
                              // doesn't do anything on true also
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(
                                  color: Colors.grey[200],
                                  width: 2.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    'Chủ đề sự kiện',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  Text(
                                    'Nội dung hoạt động trong sự kiện',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  Text(
                                    'Điểm nhấn mạnh trong sự kiện',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  Text(
                                    'Kết thúc sự kiện',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                              color: Colors.grey[50]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(80, 15, 80, 2),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 52,
                            child: RaisedButton(
                              child: Text(
                                'Đăng kí sự kiện',
                                style: TextStyle(fontSize: 18.0, color: Colors.white),
                              ),
                              // onTap: showRegisterSuccessDialog(context),
                              onPressed: () async {
                                await showDialog(
                                  context: this.context,
                                  child: new FlatButton(
                                    child: AlertDialog(
                                      title: Text(
                                        "Xin vui lòng đợi Admin duyệt đơn đăng kí của bạn",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(uid: uid, changeValue: valueChange,)),
                                        (Route<dynamic> route) => false),
                                  ),
                                );
                              },
                              color: Colors.amberAccent[400],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(6))),
                            ),
                        )
                    ),
                  ),
                ),
              ),

              // picture Unimplemented handling of missing static target
              // Container(
              //   width: 50,
              //   height: 50,
              //   child: RaisedButton(
              //     color: Colors.blue,
              //     onPressed: () => Navigator.pushAndRemoveUntil(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => TakePictureScreen()),(Route<dynamic> route) => false),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    ));
  }
}
