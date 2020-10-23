import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:designui/src/Helper/show_user_location.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/ViewModel/events_viewmodel.dart';
import 'package:designui/src/view/menu.dart';
import 'package:designui/src/view/registers_event.dart';
import 'package:designui/src/view/view_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser uid;
  final int changeValue;
  final timeStart;
  final timeStop;
  final idEvents;
  final status;
  const HomePage({Key key, this.uid,
    this.changeValue, this.timeStart, this.timeStop, this.idEvents,this.status
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState(uid, changeValue,timeStart,timeStop,idEvents,status);
}

class _HomePageState extends State<HomePage> {

  final FirebaseUser uid;
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  var timeStart ;
  var timeStop;
  int changeValue;
  var idEvents;
  var checkLocation = false;
  var status;
  var showsms = false;
  _HomePageState(this.uid, this.changeValue, this.timeStart, this.timeStop, this.idEvents,this.status);
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
      showSmS();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  void setState(fn) {
    Timer.run(() => showDiaLogLocation(context));
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: searchBar(),
              backgroundColor: Colors.orange[400],
              leading: FlatButton(
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
                child: Container(
                  width: 26,
                  height: 26,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(uid.photoUrl),
                  ),
                ),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.grey[100],
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          getListEvent(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            drawer: Drawer(
              child: HomeMenu(
                uid: uid,
              ),
            ),
          ),
        ));
  }
  // button search
  Widget searchBar() {
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.circular(10.0),
      child: TextFormField(
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: Icon(Icons.search, color: Colors.black),
              contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
              hintText: 'Tìm kiếm sự kiện',
              hintStyle: TextStyle(color: Colors.grey)),
          onFieldSubmitted: (String input) {}),
    );
  }
  // body
  Widget getListEvent() {
    var count ;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 610,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          CurrentEvents(),
          // list events current
          Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: FutureBuilder<List<EventsDTO>>(
                // get count user register events
                  future: EventsVM.getEventsPending(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        return Container(
                          margin: EdgeInsets.all(6),
                          padding: EdgeInsets.all(3),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.all(color: Colors.grey[200],
                                width: 1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(
                                    15.0)), // set rounded corner radius
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context,snap){
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: changeValue == null ? new Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => RegisterEventPage(
                                                    uid: uid, eventsDTO: snapshot.data[snap],count:snap+1)));
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(15.0),
                                            child: Image.asset(
                                              'assets/images/events${snap+1}.png',
                                              width: 140,
                                              height: 140,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                          : new Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: FlatButton(
                                          onPressed: () => {Timer.run(() => showDiaLogLocation(context)),},
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(15.0),
                                            child: Image.asset(
                                              'assets/images/events${snap+1}.png',
                                              width: 140,
                                              height: 140,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(snapshot.data[snap].title,),
                                    Text(dtf.format(DateTime.parse(snapshot.data[snap].startedAt))),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      };
                    };
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      // loading when not found
                      child: Center(child: CircularProgressIndicator()),
                    );
                  })),
          UpcomingEvents(),
          // list events upcoming
          Container(
            width: MediaQuery.of(context).size.width,
            height: 550,
            child: FutureBuilder<List<EventsDTO>>(
                future: EventsVM.getAllListEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        // get count user register events
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, snap) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[200], width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            child: FlatButton(
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Column(children: <Widget>[
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 6,
                                          child: Center(
                                            child: changeValue == null
                                                ? new Padding(
                                              padding: const EdgeInsets.all(0.0),
                                              child: FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => RegisterEventPage(
                                                          uid: uid, eventsDTO: snapshot.data[snap],count:snap + 1)));
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(15.0),
                                                  child: Image.asset(
                                                    'assets/images/events${snap + 1}.png',
                                                    width: double.infinity,
                                                    height: 140,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            )
                                                : new Padding(
                                              padding: const EdgeInsets.all(0.0),
                                              child: FlatButton(
                                                onPressed: ()=>{
                                                  Timer.run(() => showDiaLogLocation(context)),
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(15.0),
                                                  child: Image.asset(
                                                    'assets/images/events${snap + 1}.png', width: 140,
                                                    height: 140, fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(snapshot.data[snap].title,
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                                              ),
                                              Text(dtf.format(DateTime.parse(snapshot.data[snap].startedAt)),style: TextStyle(fontSize: 16.0),),

                                            ],
                                          ),
                                        ),
                                      ])
                                ]),
                              ),
                            ),
                          );
                        },
                      );
                    };
                  };
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    // loading when not found
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
  // check time current with time event => show notification user
  showDiaLogLocation(BuildContext context) async {
    final now = DateTime.now();
    try{
      if (now.isAfter(dtf.parse(timeStart)) && now.isBefore(dtf.parse(timeStop))) {
        // notification get location for user
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Thông báo"),
              content: Text("Checking để tham gia sự kiện"),
              actions: [
                CupertinoButton(
                  child: Text('Đồng ý'),
                  onPressed: () async {
                     await Future.delayed(Duration.zero, () {
                        Navigator.of(context).pop(true);
                    });
                    checkLocation = true;
                  },
                ),
                CupertinoButton(
                  child: Text('Hủy'),
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
    }catch(e){
      throw(e);
    }
  }

  // get location auto
  getAutoLocation(){
    if(checkLocation == true) {
      show showEvents = new show();
      showEvents.showLocationDiaLog(timeStart, timeStop, idEvents);
    }else{
      checkLocation = false;
    }
  }

  // show messasign when user login success
  showSmS(){
    if(status == ""){
      Fluttertoast.cancel();
    }else{
      Fluttertoast.showToast(
          msg: status,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 7,
          fontSize: 24.0,
          textColor: Colors.black);
      sleep(Duration(seconds: 0));
    }
  }

  // Title current events
  Widget CurrentEvents(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(20, 0, 7, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Sự kiện sắp diễn ra ",
              style: TextStyle(
                  color: Colors.orange[400],
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
            ),
            FlatButton(
              child: Text(
                "Hiện tất cả",
                style: TextStyle(
                    color: Colors.orange[400], fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShowAllEventsPage(uid: uid)));
              },
            ),
          ]),
    );
  }

  // Title upcoming events
  Widget UpcomingEvents(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(20, 0, 7, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Sự kiện sắp tới",
              style: TextStyle(
                  color: Colors.orange[400],
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
            ),
            FlatButton(
              child: Text(
                "Hiện tất cả",
                style: TextStyle(
                    color: Colors.orange[400], fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShowAllEventsPage(uid: uid)));
              },
            ),
          ]),
    );
  }

}