import 'dart:async';
import 'package:designui/src/Helper/camera_plugin.dart';
import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/Model/feedbackDAO.dart';
import 'package:designui/src/Model/registerEventDAO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:designui/src/View/feedback.dart';
import 'package:designui/src/View/home.dart';
import 'package:designui/src/ViewModel/events_viewmodel.dart';
import 'package:designui/src/ViewModel/register_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterEventPage extends StatefulWidget {
  final FirebaseUser uid;
  final int idEvents;
  final status;
  final tracking;
  final nameEvents;
  final screenHome;

  const RegisterEventPage({Key key, this.uid,this.idEvents,this.status,this.tracking,this.nameEvents,scaffoldGlobalKey,this.screenHome}) : super(key: key);

  @override
  _RegisterEventPageState createState() => _RegisterEventPageState(uid,idEvents,status,tracking,nameEvents,screenHome);
}

class _RegisterEventPageState extends State<RegisterEventPage> {
  final FirebaseUser uid;
  final tracking;
  final nameEvents;
  final screenHome;
  GlobalKey scaffoldGlobalKey;
  var idEvents;
  var _timeStart;
  var timeStop ;
  var status;
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  DateFormat sqlDF = DateFormat('yyyy-MM-ddTHH:mm:ss');
  var checkValue = false;
  var checkApp = false;
  var _tmpStatusEvent;
  var checkInUser = false;
  String dropdownValue;
  var eventLocation;
  var handlerButtonClick =false;

  Map<String, dynamic> decodedToken;
  _RegisterEventPageState(this.uid,this.idEvents,this.status,this.tracking,this.nameEvents,this.screenHome);

  @override
  void initState(){
    userCheckIn();
    locationOfEvent();

    print('idEvent ${idEvents} ----------- ');

    dropdownValue = "Any";
    dropdownSemester();
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
              key: scaffoldGlobalKey,
              appBar: myAppBar(),
              body: FutureBuilder(
                future: Future.delayed(Duration(seconds: 1)),
                builder: (c, s) => s.connectionState == ConnectionState.done
                  ? FutureBuilder<EventsDTO>(
                      future: EventsVM().getEventFlowId(idEvents),
                      builder: (context, snapshot) {
                        if(snapshot.data != null) {
                          try {
                            convertDateTime(snapshot.data);
                          } catch (e) {}
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
                    // Image.network("${dto.picture}",
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 180,
                    //   fit: BoxFit.fill,
                    // ),
                    Image.network(
                      'https://skitguys.com/imager/stillimages/135292/Orion_Upcoming_Events_Still_HPM-HD_aadcc2b1f9fa535f36249a03e9ea56d2.jpg',
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
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
                  child: Text(dtf.format(DateTime.parse(dto.startedAt)),
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
                      eventLocation !=null
                          ? await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text("Event Loaction"),
                                content: new Text("Title :${eventLocation.title}\nRoom :${eventLocation.roomNumber}\nFloor :${eventLocation.floor}"
                                    "\nAddress :${eventLocation.address}"),
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
                              ?Tooltip(message: "Event location detail", child: Text("${ShowMessage.functionLimitCharacter(eventLocation.title)}",textAlign: TextAlign.start))
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
                  child: Text("${dto.duration * 60} minutes ", style: TextStyle(color: Colors.black, fontSize: 16.0),),
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
                  child:  dto.host!= null
                      ? Text(dto.host,style: TextStyle(color: Colors.black, fontSize: 16.0,),)
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
                    Icon(Icons.weekend),
                    SizedBox(width: 5,),
                    Text('Remaining seats',style: TextStyle(color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold)),
                    // SizedBox(width: 80,),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50,top: 10),
                  child: Text("${dto.capacity.toString()}", style: TextStyle(color: Colors.black, fontSize: 16.0),)
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
                    child: _tmpStatusUser != null && _tmpStatusUser != "this event you have not registered yet" ? Padding(
                      padding: const EdgeInsets.all(0),
                      child: _tmpStatusUser != "pending" ? Padding(
                        padding: const EdgeInsets.all(0),
                        child: _tmpStatusUser != "accepted" ? Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text('Rejected',style: TextStyle(color: Colors.red, fontSize: 16.0),textAlign: TextAlign.start,),
                        ):Text('Accepted',style: TextStyle(color: Colors.green, fontSize: 16.0),textAlign: TextAlign.start,),
                      ):Text('Events is not unapproved',style: TextStyle(color: Colors.amber, fontSize: 15.0),textAlign: TextAlign.start,),
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
                  child: Text(dto.content,style: TextStyle(color: Colors.black, fontSize: 16.0),),
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
            child: status != "This event you have completed" ? Center(
              child: _tmpStatusUser != null && _tmpStatusUser != "this event you have not registered yet" && _tmpStatusUser != "canceled"? Center(
                child: _tmpStatusUser != "pending" ? Center(
                    child: _tmpStatusUser == "rejected" && _tmpStatusUser !="accepted"? Center(
                        child:buttonDetails(3.0, 3.0,"Rejected")
                    ): Container(
                        width: MediaQuery.of(context).size.width,
                        height: 52,
                          child: buttonCheckin(dto)),
                ): buttonDetails(3.0,3.0,"Cancel"),
              ):Container(
                  width: MediaQuery.of(context).size.width,
                  height: 52,
                  child:buttonRegister(dto)),
            ) : buttonFeedBack(4.0, 4.0,dto),
        ),
      ),
    );

  }

  // button cancel events and reject events
  Widget buttonDetails(bottom,top,title){
    return Row(
      children: <Widget>[
        Visibility(
          visible: true,
          child: Container(
            width: MediaQuery.of(context).size.width*94.5/100,
            height: MediaQuery.of(context).size.height*12/100,
            child: Padding(
              padding: EdgeInsets.only(left: 16,bottom: bottom,top: top),
                child: title == "Cancel"
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
                                Icon(Icons.notifications,),
                                SizedBox(width: 10,),
                                Text("Message"),
                              ]
                          ),
                        content:  Text("Cancel registered the event",style: TextStyle(fontSize: 16.0,),textAlign: TextAlign.center,),
                          actions: [
                            new FlatButton(
                              child: Text("Yes",style: TextStyle(color: Colors.blue[500]),),
                              onPressed: () async {
                                //get this id events
                                var id = await RegisterEventDAO().idOfEvent(idEvents);

                                // if user cancel this event then show messages
                                RegisterVM regVM = new RegisterVM();
                                var _tmpMessage = await regVM.updateStatusEvent("CANCELED", id, false);
                                Navigator.pop(context);
                                Future.delayed(Duration(microseconds: 500),() async {
                                });
                                await ShowMessage.functionShowDialog("Canceled "+_tmpMessage,context);
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
                    :RaisedButton(
                    color: Colors.orange[600],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Text("Rejected",style: TextStyle(color: Colors.white))),
              ),
          ),
        ),
        SizedBox(width: 15,),
      ],
    );
  }

  // button feedback events
  Widget buttonFeedBack(bottom,top,EventsDTO dto){
    var tmp = true;
    return Row(
      children: <Widget>[
        Visibility(
          visible: true,
          child: Container(
            width: MediaQuery.of(context).size.width*94/100,
            height: MediaQuery.of(context).size.height*12/100,
            child: Padding(
              padding: EdgeInsets.only(left: 16,bottom: bottom,top: top),
              child: RaisedButton(
                  color: Colors.orange[600],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  onPressed: () async {
                    bool statusCheckIn = await RegisterEventDAO().statusCheckIn(int.parse(decodedToken["userId"]), idEvents);
                    bool feedBack = await FeedBackDAO().checkFeedBack(int.parse(decodedToken["userId"]), idEvents);
                    bool statusEvent = await RegisterEventDAO().eventCompleted(idEvents, "Completed");

                    if(statusCheckIn == false && feedBack == true && statusEvent == false){
                      ShowMessage.functionShowDialog("This event is not completed for feedback", context);
                      // status == true and feedback not found and status event == completed then show feedback for user
                    }else if(statusCheckIn == true && feedBack == false && statusEvent == true){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        FeedBackPage(uid: uid, nameEvents: dto.title, idEvent: idEvents,)));
                    }
                  },
                  child: Text("FeedBack",style: TextStyle(fontSize: 18.0, color: Colors.white)))
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
              await showDialog(
                context: this.context,
                child: AlertDialog(
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications),
                        SizedBox(width: 10,),
                        Text('Confirm information'),
                      ]
                  ),
                  content: Container(
                    height: MediaQuery
                        .of(context)
                        .copyWith()
                        .size
                        .height / 9.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Semester', style: TextStyle(fontSize: 16),),
                        SizedBox(height: 10,),
                        dropdownSemester() == null ?Text(''):dropdownSemester(),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CupertinoButton(
                          child: Text('Yes', style: TextStyle(color: Colors
                              .blue[500]),),
                          onPressed: () async {
                            // check semester and student code
                            if (dropdownValue == "Any") {
                              var tmpValue = 0.toString();
                              setState(() {
                                dropdownValue = tmpValue;
                              });
                            }

                            // register event
                            var _tmpStatus = await RegisterVM().register(
                                new RegisterEventsDTO(eventId: idEvents,
                                    semester: int.parse(dropdownValue),
                                    studentId: int.parse(
                                        decodedToken["userId"])),
                                dto.approvalRequired);

                            Navigator.of(context).pop();
                            Future.delayed(new Duration(milliseconds: 1),()async{
                            });
                            // show message when registered
                            await ShowMessage.functionShowDialog(
                                _tmpStatus, context);
                          },
                        ),
                        CupertinoButton(
                          child: Text('No', style: TextStyle(color: Colors
                              .blue[500]),),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
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
      // timeToCancel(dto) == true
      //     ? Padding(
      //       padding: const EdgeInsets.only(right: 16, left: 16,bottom: 1),
      //       child: timeToCheckin(dto) == true ?
          checkInUser == false
              ? RaisedButton(
                      child: Text('Check in', style: TextStyle(fontSize: 18.0, color: Colors.white),),
                      onPressed: () async {
                        // get id register
                        var idRegister = await RegisterEventDAO().idOfEvent(idEvents);
                        // get status user register
                        var statusCheckIn = await RegisterVM().statusRegisterEvent(int.parse(decodedToken["userId"]), idEvents);
                        await Future.delayed(Duration.zero, () {
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (BuildContext context) =>
                              CameraApp(uid: uid,
                                  duration: dto.duration,
                                  nameEvents: dto.title,
                                  tracking:dto.gpsTrackingRequired,
                                  idEvents: dto.id,
                                  idRegister: idRegister,
                                  statusCheckin :statusCheckIn,
                              )), (
                              Route<dynamic> route) => false);
                        });
                      },
                      color: Colors.orange[600],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                  )
              : RaisedButton(
                onPressed: (){
                  ShowMessage.functionShowDialog("Your have already checkin this event", context);
                },
                color: Colors.orange[600],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Text('Check in',style: TextStyle(fontSize: 18.0, color: Colors.white)),
              )
          // : RaisedButton(
            // onPressed: (){
              // ShowMessage.functionShowDialog("This event has not yet start", context);
            // },
            //   color: Colors.orange[600],
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
        //       child: Text('Check in', style: TextStyle(fontSize: 18.0, color: Colors.white),),),
        // ):buttonDetails(3.0,3.0,"Cancel"),
    );
  }

  // check time user can to cancele
  timeToCancel(EventsDTO dto){
    DateTime tmpDT = DateTime.parse(dto.startedAt);
    tmpDT = tmpDT.add(new Duration(hours:-12));
    var now = DateTime.now();
    if(dto.cancelUnavailableAt == null){
      if (now.isAfter(tmpDT)) {
        checkValue = true;
        return checkValue;
      }else {
        checkValue = false;
        return checkValue;
      }
    }else {
      if(now.isBefore(DateTime.parse(dto.cancelUnavailableAt))) {
        checkValue = true;
        return checkValue;
      }else {
        checkValue = false;
        return checkValue;
      }
    }
  }

  // check time events is in an on going range
  timeToCheckin(EventsDTO dto) async{
    var now = DateTime.now();
    // time + 10 minutes
    var timeToLate = DateTime.parse(dto.startedAt).add(new Duration(minutes: 10));
    // if is after time start or is before 10 minutes then not check in
    if (now.isAfter(DateTime.parse(dto.startedAt)) && now.isBefore(timeToLate)) {
      checkValue = true;
      return checkValue;
    } else{
      checkValue = false;
      return checkValue;
    }
  }

  // convert Date time db => data time ('HH:mm dd/MM/yyyy')
  convertDateTime(EventsDTO dto) async{
    try {
      int hours = int.parse(dto.duration.toString());
      // get Time in json
      _timeStart = dto.startedAt;
      // format time to sqlDF
      DateTime pTimeStart = sqlDF.parse(_timeStart);
      //add hours finish events
      timeStop = pTimeStart.add(new Duration(hours: hours)).toString();
    }catch(e){
    }
  }

  // get status event
  Future<dynamic> statusUserRegistation() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token_data");
      decodedToken = JwtDecoder.decode(token);
      // check user registered this events or not
      _tmpStatusEvent = await RegisterVM().statusRegisterEvent(int.parse(decodedToken["userId"]), idEvents);
      if(_tmpStatusEvent == null){
        print('User can register'+_tmpStatusEvent);
      }
    }catch(e){
    }
    return _tmpStatusEvent;
  }

  // button dropdown semester
  dropdownSemester() {
    try {
      return DropdownButtonFormField<String>(
        disabledHint: Text('${dropdownValue}'),
        isExpanded: true,
        value: dropdownValue,
        icon: Icon(Icons.arrow_downward, color: Colors.blue[500],),
        iconSize: 24,
        onChanged: (newValue) async {
          setState(() {
            dropdownValue = newValue;
          }
          );
        },
        items: <String>['Any', '1', '2', '3', '4', '5', '6', '7', '8', '9',]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    }catch(e){

    }
  }

  // check if the user has checked in yet
  Future<dynamic> userCheckIn() async {
    final prefs = await SharedPreferences.getInstance();
    var idOfEvent = prefs.get("idEventCamera");
    setState(() {
      if (idOfEvent == idEvents) {
        checkInUser = true;
        return checkInUser;
      }
      return checkInUser;
    });
  }

  // get id location
  locationOfEvent() async {
    try {
      List tmpLocation = await RegisterVM().getLoactionEvent(idEvents);
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

}
