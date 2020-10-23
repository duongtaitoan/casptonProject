
import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/Model/registerEventDAO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:designui/src/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '';

class RegisterEventPage extends StatefulWidget {
  final FirebaseUser uid;
  final int count;
  final EventsDTO eventsDTO;
  const RegisterEventPage({Key key, this.uid, this.eventsDTO,this.count}) : super(key: key);

  @override
  _RegisterEventPageState createState() => _RegisterEventPageState(uid, eventsDTO,count);

}

class _RegisterEventPageState extends State<RegisterEventPage> {
  final FirebaseUser uid;
  var count;
  var timeStart;
  var timeStop ;
  var valueChange = 2;
  var status;
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  DateFormat sqlDF = DateFormat('yyyy-MM-ddTHH:mm:ss');
  var statusGPS = false;
  EventsDTO eventsDTO;
  _RegisterEventPageState(this.uid,this.eventsDTO,this.count);
  checkTimeStop(){
    int hours = int.parse(eventsDTO.duration.toString());
    // get Time in json
    timeStart = eventsDTO.startedAt;
    // format time to sqlDF
    DateTime pTimeStart = sqlDF.parse(timeStart);
    //add house finish events
    timeStop = pTimeStart.add(new Duration(hours:hours)).toString();
  }


  @override
  void initState() {
    status ="";
    checkTimeStop();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Chi tiết sự kiện'),
                backgroundColor: Colors.orange[400],
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                uid: uid, status:status
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
                    Image.asset("assets/images/events$count.png",
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5,bottom: 5),
                      child: Text(eventsDTO.title ,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,),textAlign: TextAlign.center,
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
                                  child:  Row(
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
                                    Text(dtf.format(DateTime.parse(eventsDTO.startedAt)),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17.0)),
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
                                      Text(dtf.format(DateTime.parse(timeStop)).toString(),
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 17.0)),
                                    ],
                                  ),
                              )),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 5,
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
                                  width: 7,
                                ),
                                Text("Số lượng",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18.0)),
                                SizedBox(
                                  width: 90,
                                ),
                                Text(eventsDTO.maximumParticipant.toString(), style:
                                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 240.0,
                                child: Card(
                                    borderOnForeground: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(
                                        color: Colors.grey[200],
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: ListTile(
                                            title: Text('Chủ đề sự kiện',
                                              style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.bold, fontSize: 20.0),textAlign: TextAlign.start,),
                                            subtitle: Text(eventsDTO.title,style: TextStyle(
                                                color: Colors.black, fontSize: 18.0),textAlign: TextAlign.start,),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child:  ListTile(
                                            title: Text('Nội dung sự kiện',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0),textAlign: TextAlign.start,),
                                            subtitle: Text(eventsDTO.description,style: TextStyle(
                                                color: Colors.black, fontSize: 18.0),textAlign: TextAlign.start,),
                                          ),
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
                                            title: Text('Thông báo'),
                                            content: Text(
                                              "Bạn có muốn đăng kí sự kiện này không ?",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            actions: <Widget>[
                                              CupertinoButton(
                                                child: Text('Đồng ý'),
                                                  onPressed: () async {
                                                  RegisterEventDAO regisDao = new RegisterEventDAO();
                                                  statusGPS = true;
                                                  status = await regisDao.registerEvents(new RegisterEventsDTO(eventId: eventsDTO.id));
                                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                                      builder: (context) => HomePage(uid: uid, changeValue: valueChange,
                                                          timeStart:dtf.format(DateTime.parse(eventsDTO.startedAt)),timeStop:dtf.format(DateTime.parse(timeStop)).toString(),
                                                          idEvents:eventsDTO.id,status:status),), (Route<dynamic> route) => false);
                                                },
                                              ),
                                              CupertinoButton(
                                                child: Text('Hủy'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                          onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                                  builder: (context) => HomePage(uid: uid,
                                                      timeStart:dtf.format(DateTime.parse(eventsDTO.startedAt)),timeStop:dtf.format(DateTime.parse(timeStop)).toString(),
                                                      idEvents:eventsDTO.id)), (Route<dynamic> route) => false),
                                        ),
                                      );
                                    },
                                    color: Colors.orange[400],
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
