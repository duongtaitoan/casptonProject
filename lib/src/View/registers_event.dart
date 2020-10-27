import 'dart:async';
import 'package:designui/src/Helper/camera_plugin.dart';
import 'package:designui/src/Helper/show_user_location.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/Model/registerEventDAO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:designui/src/View/history.dart';
import 'package:designui/src/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterEventPage extends StatefulWidget {
  final FirebaseUser uid;
  final int count;
  final status;
  final EventsDTO eventsDTO;
  const RegisterEventPage({Key key, this.uid, this.eventsDTO,this.count,this.status}) : super(key: key);

  @override
  _RegisterEventPageState createState() => _RegisterEventPageState(uid, eventsDTO,count,status);

}

class _RegisterEventPageState extends State<RegisterEventPage> {
  final FirebaseUser uid;
  var checkLocation = false;
  var count;
  var _timeStart;
  var timeStart;
  var timeStop ;
  var nameEvents;
  var status;
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  DateFormat sqlDF = DateFormat('yyyy-MM-ddTHH:mm:ss');
  var statusGPS = false;
  EventsDTO eventsDTO;
  _RegisterEventPageState(this.uid,this.eventsDTO,this.count,this.status);

  @override
  void initState() {
    converDateTime();
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
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
                  onPressed: () =>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) => HomePage(uid: uid, status: status,
                          timeStart:dtf.format(DateTime.parse(eventsDTO.startedAt)),timeStop:dtf.format(DateTime.parse(timeStop)).toString(),
                          idEvents:eventsDTO.id,nameEvents: eventsDTO.title,)), (Route<dynamic> route) => false),
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
                    timeEvent(),
                    contentEvent(),
                    registerEvent(),
                  ],
                ),
              ),
            ),
    ));
  }

  // time start and time stop of event
  Widget timeEvent(){
    return Container(
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
    );
  }
  // slot and content event
  Widget contentEvent(){
    return Flexible(
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
                SizedBox(width: 7,),
                Text("Số lượng", style: TextStyle(color: Colors.black, fontSize: 18.0)),
                SizedBox(width: 90,),
                Text(eventsDTO.maximumParticipant.toString(), style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ],
            ),
            SizedBox(height: 5,),
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
    );
  }
  // button register and showdialog
  Widget registerEvent(){
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(80, 15, 80, 2),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 52,
          child: status != "Lịch sử người dùng" ? new Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 52,
                child: status == null || status != "Người dùng đã đăng ký sự kiện" ?
                new RaisedButton(
                  child: Text(
                    'Đăng ký sự kiện',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  onPressed: () async {
                    await showDialog(
                      context: this.context,
                      child: new FlatButton(
                        child: AlertDialog(
                          title: Text('Thông báo'),
                          content: Text(
                            "Bạn có muốn đăng ký sự kiện này không ?",
                            style: TextStyle(fontSize: 17),
                          ),
                          actions: <Widget>[
                            CupertinoButton(
                              child: Text('Đồng ý',style: TextStyle(color: Colors.blue[500]),),
                              onPressed: () async {
                                RegisterEventDAO regisDao = new RegisterEventDAO();
                                statusGPS = true;
                                status = await regisDao.registerEvents(new RegisterEventsDTO(eventId: eventsDTO.id));
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                  builder: (context) => HomePage(uid: uid, nameEvents: eventsDTO.title,
                                      timeStart:dtf.format(DateTime.parse(eventsDTO.startedAt)),timeStop:dtf.format(DateTime.parse(timeStop)).toString(),
                                      idEvents:eventsDTO.id,status:status),), (Route<dynamic> route) => false);
                              },
                            ),
                            CupertinoButton(
                              child: Text('Hủy',style: TextStyle(color: Colors.red),),
                              onPressed: () {Navigator.of(context).pop();},
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                ): new RaisedButton(
                  child: Text('Tham gia sự kiện',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),),
                    onPressed: () async {
                      setState(() {showDiaLogLocation(context);});
                    },
                  color: Colors.orange[400],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
              )
          ) :new Center(
              child: Container(
              width: MediaQuery.of(context).size.width,
              height: 52,
              child: RaisedButton(
                child: Text('Sự kiện bạn đã tham gia',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),),
                onPressed: () {
                  status = 'Lịch sử người dùng';
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) =>
                          HistoryPage(uid: uid, status: status,)), (
                      Route<dynamic> route) => false);
                },
                color: Colors.orange[400],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
              ),
              ),
          ),
        ),
      ),
    );
  }
  // check date time start - duration => date time stop
  converDateTime(){
    int hours = int.parse(eventsDTO.duration.toString());
    // get Time in json
    _timeStart = eventsDTO.startedAt;
    // format time to sqlDF
    DateTime pTimeStart = sqlDF.parse(_timeStart);
    //add house finish events
    timeStop = pTimeStart.add(new Duration(hours:hours)).toString();
  }

  // check time current with time event => show notification user
  showDiaLogLocation(BuildContext context) async {
    var now = DateTime.now();
    if (now.isAfter(DateTime.parse(eventsDTO.startedAt)) && now.isBefore(DateTime.parse(timeStop))) {
        // notification get location for user
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Thông báo"),
              content: Text("Events ${eventsDTO.title} đang diễn ra. Để tham gia sự kiện xin vui lòng check in"),
              actions: [
                CupertinoButton(
                  child: Text('Đồng ý',style: TextStyle(color: Colors.blue[500]),),
                  onPressed: () async {
                     checkLocation = true;
                    await Future.delayed(Duration.zero, () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) =>
                          CameraApp(uid:uid,status:status,timeStart: timeStart,timeStop: timeStop,nameEvents:eventsDTO.title)),(Route<dynamic> route) => false);
                    });
                  },
                ),
                CupertinoButton(
                  child: Text('Hủy',style: TextStyle(color: Colors.red),),
                  onPressed: () async {
                    await Future.delayed(Duration.zero, () {
                      Navigator.of(context).pop(true);
                    });
                  },
                )
              ],
            )
        );
      getAutoLocation();
      }
  }

  // get location auto
  getAutoLocation(){
    if(checkLocation == true) {
      show showEvents = new show();
      showEvents.showLocationDiaLog(dtf.format(DateTime.parse(eventsDTO.startedAt)), dtf.format(DateTime.parse(timeStop)), eventsDTO.id);
    }else{
      checkLocation = false;
    }
  }
}
