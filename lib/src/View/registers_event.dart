import 'dart:async';
import 'dart:io';
import 'package:designui/src/Helper/camera_plugin.dart';
import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/Helper/show_user_location.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/Model/feedbackDAO.dart';
import 'package:designui/src/Model/registerEventDAO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:designui/src/View/feedback.dart';
import 'package:designui/src/View/home.dart';
import 'package:designui/src/ViewModel/events_viewmodel.dart';
import 'package:designui/src/ViewModel/register_viewmodel.dart';
import 'package:designui/src/ViewModel/tracking_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uiblock/uiblock.dart';

class RegisterEventPage extends StatefulWidget {
  final FirebaseUser uid;
  final int idEvents;
  final status;
  final tracking;
  final nameEvents;
  final screenHome;
  final nameLocation;
  const RegisterEventPage({Key key,
    this.uid,this.idEvents,this.status,this.tracking,this.nameEvents,scaffoldGlobalKey,this.screenHome,this.nameLocation}) : super(key: key);

  @override
  _RegisterEventPageState createState() => _RegisterEventPageState(uid,idEvents,status,tracking,nameEvents,screenHome,nameLocation);
}

class _RegisterEventPageState extends State<RegisterEventPage> {
  final FirebaseUser uid;
  final tracking;
  final nameEvents;
  final screenHome;
  final nameLocation;
  var idEvents;
  var status;
  DateFormat dtf = DateFormat('HH:mm a dd/MM/yyyy');
  DateFormat sqlDF = DateFormat('yyyy-MM-ddTHH:mm:ss');
  var checkTimeCancel = false;
  var checkTimeCheckin = false;
  var checkApp = false;
  var _tmpStatusEvent;
  var checkInUser = false;
  String dropdownValue;
  var eventLocation;
  var handlerButtonClick =false;
  var barSelect = 1;

  GlobalKey _scaffoldGlobalKey = GlobalKey();
  Map<String, dynamic> decodedToken;
  _RegisterEventPageState(this.uid,this.idEvents,this.status,this.tracking,this.nameEvents,this.screenHome,this.nameLocation);

  @override
  void initState(){
    userCheckIn();
    locationOfEvent();
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
              key: _scaffoldGlobalKey,
              appBar: myAppBar(),
              body: FutureBuilder(
                future: Future.delayed(Duration(milliseconds:500)),
                builder: (c, s) => s.connectionState == ConnectionState.done
                  ? FutureBuilder<EventsDTO>(
                      future: EventsVM().getEventFlowId(idEvents),
                      builder: (context, snapshot) {
                        if(snapshot.data != null) {
                          return myBody(snapshot.data);
                        }
                        return Center (
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center (
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image(image: AssetImage("assets/images/tenor.gif"),width: 300,height: 300,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                  })
                  :Center ()
              )
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
        child:FutureBuilder(
          future: statusUserRegistation(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              try {
                return Column(
                  children: <Widget>[
                    dto.banner== null
                        ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.3,
                          child: Center(child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              new CircularProgressIndicator(),
                              new Text("Loading"),
                            ],),),
                        )
                    :Image.network("${dto.banner}",
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text('${dto.title}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25.0,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20,),
                    contentEvent(dto, snapshot.data),
                    registerEvent(dto, snapshot.data),
                  ],
                );
              }catch(e){
              }
            }
            return Center();
          },
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
        onPressed: () async {
          if(screenHome == "HomePage") {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => HomePage(uid: uid)), (
                Route<dynamic> route) => false);
          }else{
            Navigator.of(context).pop();
          }
        }
      ),
    );
  }

  // content details of event
  Widget contentEvent(EventsDTO dto,statusUser){
    var _tmpStatusUser = statusUser.toString().toLowerCase();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //start at
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16,),
                    Image.asset('assets/images/date_time.png', width: 25, height: 25,),
                    SizedBox(width: 5,),
                    Text('Start at',style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold)),
                    // SizedBox(width: 80,),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50,top: 10),
                  child: Text(dtf.format(DateTime.parse(dto.startTime)),
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                ),
                SizedBox(height: 30,),
              ],
            ),
            // location
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 15,),
                    Icon(Icons.location_on),
                    SizedBox(width: 6,),
                    Text('Location',style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35,top: 10),
                  child: FlatButton(
                    onPressed: () async {
                      eventLocation != null
                          ? await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text("Event Loaction"),
                                content: new Text("Title :${eventLocation["preferredName"]}\nRoom :${eventLocation["roomNumber"]}\nFloor :${eventLocation["floor"]}"
                                    "\nAddress :${ShowMessage.utf8convert(eventLocation["address"])}"),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("Close"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          ):null;
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                         eventLocation != null
                              ?Tooltip(message: "Event location detail", child: Text("${ShowMessage.functionLimitCharacter(eventLocation["preferredName"])}",textAlign: TextAlign.start))
                              :Tooltip(message: "Unknown location detail", child: Text("Unknown", textAlign: TextAlign.start)),
                         Icon(Icons.arrow_forward_ios,size: 15,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30,),
              ],
            ),
            // duration
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16,),
                    Icon(Icons.timer, size: 25,),
                    SizedBox(width: 5,),
                    Text('Duration',style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold)),
                    // SizedBox(width: 80,),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50,top: 10),
                  child: Text("${dto.trackingInterval} minutes ", style: TextStyle(color: Colors.black, fontSize: 16.0),),
                ),
                SizedBox(height: 30,),
              ],
            ),
            // Host
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16,),
                    Icon(Icons.location_city),
                    SizedBox(width: 5,),
                    Text('Host',style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold)),
                    // SizedBox(width: 80,),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50,top: 10),
                  child:  dto.hostName!= null
                      ? Text(dto.hostName,style: TextStyle(color: Colors.black, fontSize: 16.0,),)
                      : Text("Unknown",style: TextStyle(color: Colors.black, fontSize: 16.0,),),
                ),
                SizedBox(height: 30,),
              ],
            ),
            // tracking requirted
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16,),
                    Icon(Icons.gps_fixed),
                    SizedBox(width: 5,),
                    Text('Tracking required',style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold)),
                    // SizedBox(width: 80,),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50,top: 10),
                  child:dto.gpsTrackingRequired.toString() == true
                      ? Text("Yes", style: TextStyle(color: Colors.black, fontSize: 16.0),)
                      : Text("No", style: TextStyle(color: Colors.black,  fontSize: 16.0),),
                ),
                SizedBox(height: 30,),
              ],
            ),
            // remaining seat
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16,),
                    Icon(Icons.warning),
                    SizedBox(width: 5,),
                    Text('Remaining seats',style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold)),
                    // SizedBox(width: 80,),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50,top: 10),
                  child: Text("${dto.maximumParticipant.toString()}", style: TextStyle(color: Colors.black, fontSize: 16.0),)
                ),
                SizedBox(height: 30,),
              ],
            ),
            // my registration status
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16,),
                    Icon(Icons.info_outline,color: Colors.black),
                    SizedBox(width: 5,),
                    Text('My registration status',style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold)),
                    // SizedBox(width: 80,),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 50,top: 10),
                    child: _tmpStatusUser != null && _tmpStatusUser != "this event you have not registered yet" &&_tmpStatusUser != "canceled"
                        && _tmpStatusUser != "can register event" && _tmpStatusUser != "you have not registered for this event before."?Padding(
                      padding: const EdgeInsets.all(0),
                      child: _tmpStatusUser != "waiting_for_approval" ? Padding(
                        padding: const EdgeInsets.all(0),
                        child: _tmpStatusUser != "approved" ? Padding(
                          padding: const EdgeInsets.all(0),
                          child: _tmpStatusUser == "checked_in"? Padding(
                              padding: const EdgeInsets.all(0),
                              child: Text('Checked in',style: TextStyle(color: Colors.orange, fontSize: 16.0),textAlign: TextAlign.start,),
                          ):Text('Registration rejected',style: TextStyle(color: Colors.red, fontSize: 16.0),textAlign: TextAlign.start,),
                        ):Text('Registration approved',style: TextStyle(color: Colors.green, fontSize: 16.0),textAlign: TextAlign.start,),
                      ):Text('Waiting for approval',style: TextStyle(color: Colors.amber, fontSize: 15.0),textAlign: TextAlign.start,),
                    ):Text('Not registered yet',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 16.0),textAlign: TextAlign.start,),
                ),
                SizedBox(height: 30,),
              ],
            ),
            // content
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 16,),
                    Icon(Icons.event_note),
                    SizedBox(width: 5,),
                    Text('Content',style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold)),
                    // SizedBox(width: 80,),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50,top: 10),
                  child: Text('${dto.description}',style: TextStyle(color: Colors.black, fontSize: 16.0),),
                ),
                SizedBox(height: 30,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // button register and approved ,reject and show history if user feedback
  Widget registerEvent(EventsDTO dto,statusUser){
    var _tmpStatusUser = statusUser.toString().toLowerCase();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*10/100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(2, 7, 2, 2),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
            child: _tmpStatusUser != "checked_in" ? Center(
              child: status != "This event you have completed"
                  ? Center(
                child: _tmpStatusUser != null && _tmpStatusUser != "this event you have not registered yet" && _tmpStatusUser != "canceled"
                  && _tmpStatusUser != "can register event" && _tmpStatusUser != "you have not registered for this event before." ?Center(
                  child: _tmpStatusUser != "waiting_for_approval" ? Center(
                      child: _tmpStatusUser == "rejected" && _tmpStatusUser !="approved" ? Center(
                          child:buttonDetails(3.0, 3.0,"Rejected",dto)
                      ): Container(
                          width: MediaQuery.of(context).size.width,
                          height: 52,
                          child: buttonCheckin(dto)),
                  ): buttonDetails(3.0,3.0,"Cancel",dto),
                ):Container(
                    width: MediaQuery.of(context).size.width,
                    height: 52,
                    child:buttonRegister(dto)),
              ) : buttonFeedBack(4.0, 4.0,dto),
            )
              :Container(
                width: MediaQuery.of(context).size.width,
                height: 52,
                child: buttonCheckin(dto)),
        ),
      ),
    );

  }

  // button cancel events and reject events
  Widget buttonDetails(bottom,top,title,dto){
    return Row(
      children: <Widget>[
        Visibility(
          visible: true,
          child: Container(
            width: MediaQuery.of(context).size.width*94.5/100,
            height: MediaQuery.of(context).size.height*12/100,
            child: Padding(
              padding: EdgeInsets.only(left: 16,bottom: bottom,top: top),
                child: title != "Rejected"
                    ? RaisedButton(
                    color: Colors.orange[600],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    onPressed: () async {
                        await showDialog(
                        context: this.context,
                        child: AlertDialog(
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:[
                                SizedBox(width: 10,),
                                Text("Message"),
                              ]
                          ),
                        content: Text("Cancel registration?",style: TextStyle(fontSize: 16.0,),textAlign: TextAlign.center,),
                          actions: [
                            new FlatButton(
                              child: Text("Yes",style: TextStyle(color: Colors.blue[500]),),
                              onPressed: () async {
                                await loadingMess(dto, "canceledRegister");
                              },
                            ),
                            new FlatButton(
                              child: Text("No",style: TextStyle(color: Colors.blue[500]),),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    }, child: Text("Cancel",style: TextStyle(fontSize: 18.0, color: Colors.white)))
                    : RaisedButton(
                    color: Colors.orange[600],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Text("${title}",style: TextStyle(color: Colors.white))),
              ),
          ),
        ),
        SizedBox(width: 15,),
      ],
    );
  }

  // button feedback events
  Widget buttonFeedBack(bottom,top,EventsDTO dto){
    // var _tmpStatusUser = dto.status.toString().toLowerCase();
    return Row(
      children: <Widget>[
        Visibility(
          visible: true,
          child: Container(
            width: MediaQuery.of(context).size.width*94/100,
            height: MediaQuery.of(context).size.height*12/100,
            child: Padding(
              padding: EdgeInsets.only(left: 16,bottom: bottom,top: top),
              child:
              // _tmpStatusUser != 'rejected' ?
              RaisedButton(
                  color: Colors.orange[600],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  onPressed: () async {
                    await loadingMess(dto,"feedback");
                  },
                  child: Text("FeedBack",style: TextStyle(fontSize: 18.0, color: Colors.white))
              )
                  // : Text("FeedBack",style: TextStyle(fontSize: 18.0, color: Colors.white))
            ),
          ),
        ),
        SizedBox(width: 15,),
      ],
    );
  }

  // button user register
  Widget buttonRegister(EventsDTO dto){
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16),
      child: new RaisedButton(
          child: Text('Register', style: TextStyle(fontSize: 16.0, color: Colors.white),),
          onPressed: () async {
            await loadingMess(dto, "register");
          },
          color: Colors.orange[600],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
    );
  }

  // button user is approved and go to checkin
  Widget buttonCheckin(EventsDTO dto){
    return Padding(
      padding: const EdgeInsets.all(0),
      child:
      // timeToCancel(dto) == false ?
        Padding(
            padding: const EdgeInsets.only(right: 16, left: 16,bottom: 1),
            child:
            // timeToCheckin(dto) != false?
            // checkInUser == false ?
            RaisedButton(
              child: Text('Check in', style: TextStyle(fontSize: 18.0, color: Colors.white),),
              onPressed: () async {
                await loadingMess(dto, "Checkin");
              },
              color: Colors.orange[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),)
              // : RaisedButton(
              //   onPressed: (){
              //       // ShowMessage.functionShowDialog("Your have already check in this event", context);
              //       // ShowMessage.functionShowDialog("You cannot checkin again", context);
              //   },
              //   // color: Colors.orange[600],
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
              //   child: Text('Check in',style: TextStyle(fontSize: 18.0, color: Colors.white)),
              // )
        //         : RaisedButton(
        //           onPressed: ()async{
        //             var now = DateTime.now();
        //             // time + checkinDuration minutes
        //             // var timeToDelay = dto.checkInDuration;
        //             var timeToLate = DateTime.parse(dto.startAcceptingRegistrationAt).add(new Duration(minutes: 5));
        //             // time user click button checkin into 5 minutes when time startAt
        //             if (now.isBefore(timeToLate)) {
        //               await ShowMessage.functionShowDialog("Time out to check in", context);
        //             }else if(now.isBefore(DateTime.parse(dto.startAcceptingRegistrationAt))){
        //             }
        //               await ShowMessage.functionShowDialog("This event has not yet start", context);
        //           },
        //             color: Colors.grey[400],
        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
        //             child: Text('Check in', style: TextStyle(fontSize: 18.0, color: Colors.white),),),
        )
        // : buttonDetails(3.0,0.0,"Cancel",dto),
    );
  }

  // get status event

  Future<dynamic> statusUserRegistation() async {
    try {
      _tmpStatusEvent = await RegisterVM().statusRegisterEvent(idEvents);
      print('${_tmpStatusEvent}');
    }catch(e){
    }
    return _tmpStatusEvent;
  }

  // check user check in event or not
  Future<dynamic> userCheckIn() async {
    final prefs = await SharedPreferences.getInstance();
    var idOfEvent = prefs.get("thisEventCheckin");
    setState(() {
      if (idOfEvent == idEvents) {
        checkInUser = true;
        return checkInUser;
      }
      return checkInUser;
    });
  }

  // get location of event
  locationOfEvent() async {
    try {
      var tmpLocation = await RegisterVM().getLoactionEvent(nameLocation);
      tmpLocation.forEach((element) {
        setState(() {
          eventLocation = element;
          return eventLocation;
        });
      });
      return tmpLocation;
    } catch(e){
      eventLocation = null;
      return eventLocation;
    }
  }

  // loading message feedback
  loadingMess(dto,nameButton) async {
    UIBlock.block(_scaffoldGlobalKey.currentContext,
      customLoaderChild: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center (
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 10,),
                    Text("Loading . . .",style: TextStyle(fontSize: 18.0,color: Colors.white),),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );

    if(nameButton == "feedback"){
      await handlerFeedback(dto);
    }else if (nameButton == "register"){
      await handlerRegister(dto);
    }else if (nameButton == "canceledRegister"){
      await handlerCancel();
    }else if(nameButton == "Checkin"){
      await handlerCheckIn(dto);
    }
  }

  // check condition of feedback
  handlerFeedback(dto) async {
    // bool statusCheckIn = await RegisterEventDAO().statusCheckIn(int.parse(decodedToken["userId"]), idEvents,"Completed");
    // bool feedBack = await FeedBackDAO().checkFeedBack(int.parse(decodedToken["userId"]), idEvents);

    // if(statusCheckIn == true && feedBack == true){
      // this event is already feedback
      // UIBlock.unblock(_scaffoldGlobalKey.currentContext);
      // ShowMessage.functionShowDialog("This event you have already feedback", context);
    // }else if(statusCheckIn == true && feedBack == false ){
      // status == true and feedback not found then show feedback for user
      UIBlock.unblock(_scaffoldGlobalKey.currentContext);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          FeedBackPage(uid: uid, nameEvents: dto.title, idEvent: idEvents,)));
    // }else if(statusCheckIn == false && feedBack == true){
      // user not check in event
      // UIBlock.unblock(_scaffoldGlobalKey.currentContext);
      // ShowMessage.functionShowDialog("This event you have not check in", context);
    // }
  }

  // check register of user
  handlerRegister(dto) async{

    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    var decodedToken= JwtDecoder.decode(token);

    // register event
    var _tmpStatus = await RegisterVM().register(idEvents);

    if(_tmpStatus != "Register Successfully"){
      Navigator.of(context).pop();
      await ShowMessage.functionShowDialog(_tmpStatus, context);
    }else {
      Navigator.of(context).pop();
      // show message when registered
      await ShowMessage.functionShowDialog(_tmpStatus, context);

      Future.delayed(Duration(microseconds: 1), () async {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) =>
                HomePage(uid: uid, barSelect: barSelect, pageIndex: 0)), (
            Route<dynamic> route) => false);
      });
      UIBlock.unblock(_scaffoldGlobalKey.currentContext);
    }
  }

  // if user cancel this event then show messages
  handlerCancel() async{
    //canceled this event
    var _tmpMessage = await RegisterVM().updateStatusEvent(idEvents);

    Navigator.of(context).pop();
    await ShowMessage.functionShowDialog(_tmpMessage,context);
    Future.delayed(Duration(microseconds: 1),() async {
      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)
      => HomePage(uid: uid)), (Route<dynamic> route) => false);
    });
    UIBlock.unblock(_scaffoldGlobalKey.currentContext);
  }

  // user click button check in
  handlerCheckIn(EventsDTO dto)async {
    // date time
    var current = DateTime.parse(dto.startTime);
    var isFuture = DateTime.parse(dto.endTime);
    var currentStart = DateTime.parse(sqlDF.format(current));
    var isFutureEnd = DateTime.parse(sqlDF.format(isFuture));
    DateFormat hh = DateFormat('HH');
    DateFormat mm = DateFormat('mm');

    // time for check in
    var timeNow = ((int.parse(hh.format(isFutureEnd))*60)+int.parse(mm.format(isFutureEnd)))
        - ((int.parse(hh.format(currentStart))*60)+int.parse(mm.format(currentStart)));

    // get status event is ongoing
    var statusCheckIn = await RegisterVM().statusEventEvent(idEvents);

    if (statusCheckIn.compareTo("ONGOING") == 0) {
        // if gps tracking required true or false alway to send location first to server
        await Future.delayed(Duration.zero, () {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (BuildContext context) =>
              CameraApp(uid: uid,
                duration: dto.trackingInterval,
                nameEvents: dto.title,
                tracking: dto.gpsTrackingRequired,
                idEvents: dto.id,
                checkInQrCode: dto.checkInQrCode,
                nameLocation: nameLocation,
                statusCheckin: statusCheckIn,
                timeEnd: DateFormat("yyyy-MM-dd hh:mm:ss").format(isFuture),
                timeDuration: timeNow,
              )), (Route<dynamic> route) => false);
        });
    }else{
      await ShowMessage.functionShowDialog("This event has not ongoing yet", context);
      UIBlock.unblock(_scaffoldGlobalKey.currentContext);
    }
  }
}
