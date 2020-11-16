import 'dart:async';
import 'dart:io';
import 'package:designui/src/Helper/camera_plugin.dart';
import 'package:designui/src/Helper/science.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/Model/registerEventDAO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:designui/src/View/home.dart';
import 'package:designui/src/ViewModel/events_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterEventPage extends StatefulWidget {
  final FirebaseUser uid;
  final int idEvents;
  final status;
  final tmpStatus;
  const RegisterEventPage({Key key, this.uid,this.idEvents,this.status,this.tmpStatus}) : super(key: key);

  @override
  _RegisterEventPageState createState() => _RegisterEventPageState(uid,idEvents,status,tmpStatus);

}

class _RegisterEventPageState extends State<RegisterEventPage> {
  final FirebaseUser uid;
  var checkLocation = false;
  var idEvents;
  var _timeStart;
  var timeStart;
  var timeStop ;
  var nameEvents;
  var status;
  var tmpStatus;
  var statusUser;
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  DateFormat sqlDF = DateFormat('yyyy-MM-ddTHH:mm:ss');
  var checkValue;
  var checkApp;
  var _tmp;
  Map<String, dynamic> decodedToken;

  final TextEditingController majorControll = new TextEditingController();
  _RegisterEventPageState(this.uid,this.idEvents,this.status,this.tmpStatus);

  Future<dynamic> statusUserCode() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    decodedToken= JwtDecoder.decode(token);
    _tmp = await RegisterEventDAO().getInfor(decodedToken["studentCode"], idEvents);
    return _tmp;
  }

  @override
  void initState(){
    setState(() {
      statusUserCode().then((value) async {
        statusUser = value;
        print('${statusUser} -- - ');
      });
    });
    checkValue = false;
    checkApp = false;
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }
// body of register event
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
            child: Scaffold(
              appBar: myAppBar(),
              body: FutureBuilder<EventsDTO>(
                future: EventsVM().getEventFlowId(idEvents),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    converDateTime(snapshot.data);
                    if(snapshot.data != null) {
                      return myBody(snapshot.data);
                    }
                  }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                },
              ),
            ),
    ));
  }

  // body of events details
  Widget myBody(EventsDTO dto){
    return Container(
      padding: EdgeInsets.all(0),
      constraints: BoxConstraints.expand(),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network("${dto.picture}",
              width: MediaQuery.of(context).size.width,
              height: 180,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5,bottom: 5),
              child: Text('${dto.title}' ,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,),textAlign: TextAlign.center,
              ),
            ),
            timeEvent(dto),
            SizedBox(height: 20,),
            contentEvent(dto),
            registerEvent(dto),
          ],
        ),
      ),
    );
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
              if(status == "Denied"||status == "Pending"||status == "Accepted" ){
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(
                      builder: (context) => HomePage(uid: uid,)),
                      (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pop();
            }
          }
      ),
    );
  }

  // title time start and duration of event
  Widget timeEvent(EventsDTO dto){
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
                    Text(dtf.format(DateTime.parse(dto.startedAt)),
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
                    Text("${dto.duration * 60} minutes ", style: TextStyle(color: Colors.black, fontSize: 17.0,fontWeight: FontWeight.bold),),
                  ],
                ),
              )),
          SizedBox(width: 10,),
        ],
      ),
    );
  }

  // seats and content event
  Widget contentEvent(EventsDTO dto){
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
                Text(dto.Capacity.toString(), style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              children: <Widget>[
                Icon(Icons.info_outline,color: Colors.black),
                SizedBox(width: 9,),
                Text('Status',style: TextStyle(color: Colors.black, fontSize: 17.0),textAlign: TextAlign.start,),
                SizedBox(width: 80,),
                statusUser == null ? Center(
                  child: status != "Reject" && tmpStatus != "Denied" && statusUser != "Pending" ? Center(
                    child: status != "Approved" && tmpStatus !="Accepted"&&  statusUser != "Pending"
                        ?Center(child: status != "Waiting" && tmpStatus != "Pending" && statusUser == "Pending"
                            ?Text('Events not yet start',style: TextStyle(color: Colors.green, fontSize: 16.0),textAlign: TextAlign.start,)
                            :Text('Events is not unapproved',style: TextStyle(color: Colors.amber, fontSize: 15.0),textAlign: TextAlign.start,),
                        ):Text('Events is approved',style: TextStyle(color: Colors.green, fontSize: 16.0),textAlign: TextAlign.start,),
                  ) :Text('..... Reject',style: TextStyle(color: Colors.red, fontSize: 16.0),textAlign: TextAlign.start,),
                ):Text('Not registered yet',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 16.0),textAlign: TextAlign.start,),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              children: <Widget>[
                Icon(Icons.event_note),
                SizedBox(width: 7,),
                Text('Content', style: TextStyle(color: Colors.black, fontSize: 17.0),textAlign: TextAlign.start,),
              ],
            ),
            SizedBox(height: 15,),
            Text(dto.description,style: TextStyle(color: Colors.black, fontSize: 16.0),textAlign: TextAlign.start,),
            SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }

  // button register and approved or unapproved,join
  Widget registerEvent(EventsDTO dto){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*10/100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 7, 2, 2),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
            child: status != "This event you have completed" ? Center(
              child: statusUser == null && status != "Waiting" && status != "Approved" && status !="On Going" && status != "Reject"
                  && statusUser != "Pending"
                  ? Center(child:
                       new Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 52,
                          child: status == null ||  statusUser == null
                              ? eventsRegister() : buttonRejOrCan(0.0,0.0)
                        ))
              ): buttonJoin(dto),
            ) : null,
        ),
      ),
    );
  }

  // button apply and cancel events
  Widget buttonRejOrCan(bottom,top){
    return Row(
      children: <Widget>[
        status != "Waiting" && status != "Approved" && status != "Registered" && status == "Reject"
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
                              status = await RegisterEventDAO().registerEvents(
                                  new RegisterEventsDTO(eventId: idEvents));
                              Navigator.of(context).pop();
                              await showToast(status);
                              sleep(Duration(seconds: 2));
                            }else{
                              Navigator.of(context).pop();
                              await showToast("Please check value your phone or semester");
                              sleep(Duration(seconds: 2));
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
  Widget buttonJoin(EventsDTO dto){
    return Padding(
      padding: const EdgeInsets.all(0),
      child: status != "Waiting" && status != "Approved" && status != "Reject" && statusUser != "Pending" ? Padding(
        padding: const EdgeInsets.only(right: 16, left: 16,top: 4,bottom: 4),
        child: setDateTimeOfEvent(dto) == true ? RaisedButton(
          child: Text('Join', style: TextStyle(fontSize: 18.0, color: Colors.white),),
          onPressed: () async {
              await Future.delayed(Duration.zero, () {
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (BuildContext context) =>
                  CameraApp(uid: uid,
                      status: status,
                      timeStart: timeStart,
                      timeStop: timeStop,
                      nameEvents: dto.title,
                      idEvents: dto.id)), (
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
    return  Fluttertoast.showToast(
        msg: _tmpStatus,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        fontSize: 20.0,
        textColor: Colors.black
    );
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
  setDateTimeOfEvent(EventsDTO dto) async{
    var now = DateTime.now();
    if (now.isAfter(DateTime.parse(dto.startedAt)) && now.isBefore(DateTime.parse(timeStop))) {
      checkValue = true;
      return checkValue;
    }else{
      checkValue = false;
      return checkValue;
    }
  }

  // check date time start - duration => date time stop
  converDateTime(EventsDTO dto) async{
    int hours = int.parse(dto.duration.toString());
    // get Time in json
    _timeStart = dto.startedAt;
    // format time to sqlDF
    DateTime pTimeStart = sqlDF.parse(_timeStart);
    //add house finish events
    timeStop = pTimeStart.add(new Duration(hours:hours)).toString();
  }
}
