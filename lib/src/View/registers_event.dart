import 'dart:async';
import 'package:designui/src/Helper/camera_plugin.dart';
import 'package:designui/src/Helper/science.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/Model/registerEventDAO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:designui/src/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  var checkValue;
  var checkApp;

  EventsDTO eventsDTO;
  final TextEditingController majorControll = new TextEditingController();
  _RegisterEventPageState(this.uid,this.eventsDTO,this.count,this.status);

  @override
  void initState() {
    checkValue = false;
    checkApp = false;
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
              appBar: myAppBar(),
              body: Container(
                padding: EdgeInsets.all(0),
                constraints: BoxConstraints.expand(),
                color: Colors.white,
                child: SingleChildScrollView(
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
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,),textAlign: TextAlign.center,
                        ),
                      ),
                      timeEvent(),
                      SizedBox(height: 20,),
                      contentEvent(),
                      registerEvent(),
                    ],
                  ),
                ),
              ),
            ),
    ));
  }

  // my app bar
  Widget myAppBar(){
    return AppBar(
      title: Text('Event details'),
      backgroundColor: Colors.orange[600],
      elevation: 0,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (status == "This event you have completed" || status == "Waiting"||
                status == "Approved" || status == "On Going"|| status == "Reject") {
              Navigator.of(context).pop();
            } else {
              print('${status} ===========');
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) =>
                      HomePage(uid: uid,
                        status: status,
                        timeStart: dtf.format(DateTime.parse(eventsDTO.startedAt)),
                        timeStop: dtf.format(DateTime.parse(timeStop)).toString(),
                        idEvents: eventsDTO.id,
                        nameEvents: eventsDTO.title,)), (
                  Route<dynamic> route) => false);
            }
          }
      ),
    );
  }

  // title time start and duration of event
  Widget timeEvent(){
    return Container(
      height: 75,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 20,),
          Flexible(flex: 5, fit: FlexFit.tight,
              child: Container(height: 20, width: MediaQuery.of(context).size.width,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 16,),
                    Image.asset('assets/images/date_time.png', width: 25, height: 25,),
                    Text('Time start',style: TextStyle(color: Colors.black, fontSize: 17.0,)),
                    SizedBox(width: 80,),
                    Text(dtf.format(DateTime.parse(eventsDTO.startedAt)),
                        style: TextStyle(color: Colors.black, fontSize: 17.0,fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
          SizedBox(height: 20,),
          Flexible(flex: 5, fit: FlexFit.tight,
              child: Container(width: MediaQuery.of(context).size.width, height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 10,),
                    Icon(Icons.timer, size: 25,),
                    SizedBox(width: 7,),
                    Text('Duration',style: TextStyle(color: Colors.black, fontSize: 17.0)),
                    SizedBox(width: 90,),
                    Text("${eventsDTO.duration * 60} minutes ", style: TextStyle(color: Colors.black, fontSize: 17.0,fontWeight: FontWeight.bold),),
                  ],
                ),
              )),
          SizedBox(width: 10,),
        ],
      ),
    );
  }

  // seats and content event
  Widget contentEvent(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*33/100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.weekend),
                SizedBox(width: 7,),
                Text("Remaining seats", style: TextStyle(color: Colors.black, fontSize: 18.0)),
                SizedBox(width: 20,),
                Text(eventsDTO.maximumParticipant.toString(), style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ],
            ),
            SizedBox(height: 30,),
            setDateTimeOfEvent() == false
                ? Row(
              children: <Widget>[
                Icon(Icons.info_outline,color: Colors.black),
                SizedBox(width: 9,),
                Text('Status',style: TextStyle(color: Colors.black, fontSize: 17.0),textAlign: TextAlign.start,),
                SizedBox(width: 80,),
                status != "Reject"? Center(
                  child: status != "Approved"
                      ?Center(
                        child: status != "Waiting"
                          ?Text('Events not yet start',style: TextStyle(color: Colors.green, fontSize: 16.0),textAlign: TextAlign.start,)
                          :Text('Events is not unapproved',style: TextStyle(color: Colors.amber, fontSize: 15.0),textAlign: TextAlign.start,),
                      ):Text('Events is approved',style: TextStyle(color: Colors.green, fontSize: 16.0),textAlign: TextAlign.start,),
                ) :Text('..... Reject',style: TextStyle(color: Colors.red, fontSize: 16.0),textAlign: TextAlign.start,),
              ],
            )
                :null,
            SizedBox(height: 30,),
            Row(
              children: <Widget>[
                Icon(Icons.event_note),
                SizedBox(width: 7,),
                Text('Content', style: TextStyle(color: Colors.black, fontSize: 17.0),textAlign: TextAlign.start,),
              ],
            ),
            SizedBox(height: 15,),
            Text(eventsDTO.description,style: TextStyle(color: Colors.black, fontSize: 16.0),textAlign: TextAlign.start,),
            SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }

  // button register and approved or unapproved,join
  Widget registerEvent(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*10/100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 7, 2, 2),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
            child: status != "Waiting" && status != "Approved" && status !="On Going" && status != "Reject"
                ? Center(child: status != "This event you have completed"
                    ? new Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 52,
                        child: status == null || status != "Người dùng đã đăng ký sự kiện"
                            ? eventsRegister() : buttonRejOrCan(0.0,0.0)
                      ))
                    : null
              )
                : buttonJoin(),
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

  // button apply and cancel events
  Widget buttonRejOrCan(bottom,top){
    return Row(
      children: <Widget>[
        status != "Waiting" && status != "Approved" && status != "Người dùng đã đăng ký sự kiện" && status == "Reject"
          ? Visibility(
          visible: true,
          child: Container(
            width: MediaQuery.of(context).size.width*94/100,
            height: MediaQuery.of(context).size.height*12/100,
            child: Padding(
              padding: EdgeInsets.only(left: 16,bottom: bottom,top: top),
              child: RaisedButton(
                  color: Colors.orange[600],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Text("Reject",style: TextStyle(color: Colors.white))),
            ),
          ),
        )
            : Visibility(
                visible: true,
                child: Container(
                  width: MediaQuery.of(context).size.width*94.5/100,
                  height: MediaQuery.of(context).size.height*12/100,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16,bottom: bottom,top: top),
                      child: RaisedButton(
                          color: Colors.orange[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          onPressed: () {
                            // nếu thay đổi trạng thái thì chuyển từ nút hủy thành nút đăng kí
                            // nếu mà
                          },
                          child: Text("Cancel",style: TextStyle(fontSize: 18.0, color: Colors.white))),
                    ),
                ),
        ),
        SizedBox(width: 15,),
      ],
    );
  }

  // notification events
  Widget eventsRegister(){
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16),
      child: new RaisedButton(
          child: Text('Register', style: TextStyle(fontSize: 18.0, color: Colors.white),),
          onPressed: () async {
            await showDialog(
              context: this.context,
              child: new FlatButton(
                child: AlertDialog(
                  title: Text('Notification'),
                  content: Container(
                    height: MediaQuery.of(context).copyWith().size.height / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Please confirm your information to register'),
                        TextField(
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          controller: majorControll,
                          decoration: new InputDecoration(
                              labelText: 'Phone',
                              hintText: '${uid.phoneNumber}',
                              counterStyle: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 7,),
                        Text('Semester',style: TextStyle(fontSize: 16),),
                        ListTile(
                          title:ScienceDropDown()
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CupertinoButton(
                          child: Text('Agree',style: TextStyle(color: Colors.blue[500]),),
                          onPressed: () async {
                            if(checkPhone(majorControll.text) == null){
                              // RegisterEventDAO regisDao = new RegisterEventDAO();
                              // statusGPS = true;
                              status = await RegisterEventDAO().registerEvents(
                                  new RegisterEventsDTO(eventId: eventsDTO.id));
                              // Navigator.pushAndRemoveUntil(
                              //     context, MaterialPageRoute(
                              //   builder: (context) =>
                              //       HomePage(uid: uid,
                              //         nameEvents: eventsDTO.title,
                              //         timeStart: dtf.format(
                              //             DateTime.parse(eventsDTO.startedAt)),
                              //         timeStop: dtf.format(
                              //             DateTime.parse(timeStop)).toString(),
                              //         idEvents: eventsDTO.id,
                              //         status: status,),), (
                              //     Route<dynamic> route) => false);
                              Navigator.of(context).pop();
                              await showToast(status);
                            }else{
                              Navigator.of(context).pop();
                              await showToast("Please check value your phone or semester");
                              }
                            },
                        ),
                        CupertinoButton(
                          child: Text('Cancel',style: TextStyle(color: Colors.red),),
                          onPressed: () {
                            Navigator.of(context).pop();
                            },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          color: Colors.orange[600],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
    );
  }

  // button not apply in admin or apply in admin
  Widget buttonJoin(){
    return Padding(
      padding: const EdgeInsets.all(0),
      child: status != "Waiting" && status != "Approved" && status != "Reject" ? Padding(
        padding: const EdgeInsets.only(right: 16, left: 16,top: 4,bottom: 4),
        child: setDateTimeOfEvent() == true ? RaisedButton(
          child: Text('Join', style: TextStyle(fontSize: 18.0, color: Colors.white),),
          onPressed: () async {
              await Future.delayed(Duration.zero, () {
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (BuildContext context) =>
                  CameraApp(uid: uid,
                      status: status,
                      timeStart: timeStart,
                      timeStop: timeStop,
                      nameEvents: eventsDTO.title,
                      idEvents: eventsDTO.id)), (
                  Route<dynamic> route) => false);
            });
          },
          color: Colors.orange[600],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
        ) : RaisedButton(
          child: Text('Join', style: TextStyle(fontSize: 18.0, color: Colors.white),),
        ),
      ):buttonRejOrCan(4.0,4.0),
    );
  }

  // show toast
  showToast(String _tmpStatus){
    return Fluttertoast.showToast(
        msg: _tmpStatus,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        fontSize: 20.0,
        textColor: Colors.black);
  }

  // check phone number of user
  checkPhone(String value){
      String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
      RegExp regExp = new RegExp(pattern);
      if (value.length == 0) {
        return 'Please phone number is blank';
      }
      else if (!regExp.hasMatch(value)) {
        return 'Your phone number invalid \n Ex: 0838625825';
      }
      return null;
    }

  // check time events into time still join
  setDateTimeOfEvent(){
    var now = DateTime.now();
    if (now.isAfter(DateTime.parse(eventsDTO.startedAt)) && now.isBefore(DateTime.parse(timeStop))) {
      checkValue = true;
      return checkValue;
    }else{
      checkValue = false;
      return checkValue;
    }
  }
}
