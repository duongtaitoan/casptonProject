import 'dart:io';
import 'dart:ui';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/View/action_event.dart';
import 'package:designui/src/View/menu.dart';
import 'package:designui/src/ViewModel/events_viewmodel.dart';
import 'package:designui/src/view/registers_event.dart';
import 'package:designui/src/view/view_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser uid;
  final nameEvents;
  final timeStart;
  final timeStop;
  final idEvents;
  final status;

  const HomePage({Key key, this.uid,
    this.nameEvents, this.timeStart, this.timeStop, this.idEvents,this.status,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState(uid, nameEvents,timeStart,timeStop,idEvents,status);
}

class _HomePageState extends State<HomePage> {
  final FirebaseUser uid;
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  var timeStart ;
  var timeStop;
  var idEvents;
  var status;
  var nameEvents;
  var checkLocation = false;
  int selectedIndex = 0;
  _HomePageState(this.uid, this.nameEvents, this.timeStart, this.timeStop, this.idEvents,this.status);
  GlobalKey<ScaffoldState> _scaffoldKey;
  Widget _actionEvents = ActionEventsPage();

  @override
  void initState() {
    showSmS();
    _actionEvents = ActionEventsPage(uid: uid,);
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  void onItemTapped(int index) async {
    setState(() {selectedIndex = index; });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: myAppBar(),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: onItemTapped,
              backgroundColor: Colors.orange[600],
              selectedIconTheme: IconThemeData (opacity: 1.0, size: 25),
              unselectedIconTheme: IconThemeData (opacity: 0.5, size: 20),
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home,color: Colors.white),
                  title: new Text('Home',style: TextStyle(color: Colors.white),),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.event,color: Colors.white,),
                  title: new Text('Registered',style: TextStyle(color: Colors.white),),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person,color: Colors.white),
                    title: Text('Profile',style: TextStyle(color: Colors.white),)
                )
              ],
            ),
            body: screenHome(),
          ),
        ));
  }

  // show body in home when user click
  Widget screenHome( )  {
    if(this.selectedIndex == 0) {
      return this.homeBody();
    } else if(this.selectedIndex==1) {
      return this._actionEvents ;
    } else {
      return HomeMenu(uid:uid);
    }
  }

  // appbar in show then show
  Widget myAppBar(){
    if(this.selectedIndex == 0){
      return AppBar(
        title: IconSearch(),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange[600],
      );
    }else if(this.selectedIndex == 1){
      return null;
    }else{
      return null;
    }
  }

  // body home
  Widget homeBody(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  bodyEvents(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  // button search
  Widget IconSearch() {
    return Center(
      child: Row(
        children: <Widget>[
          SizedBox(width: 135,),
          Text('Home'),
          SizedBox(width: 90,),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowAllEventsPage(uid: uid,)),
                    (Route<dynamic> route) => false),
          ),
        ],
      ),
    );
  }

  // body
  Widget bodyEvents() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[200],
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          // title of current events
          titleEvents("On going events"),
          // list events current
          listEventsCurrent(),
          // title events upcoming
          titleEvents("Upcoming events"),
          // list events upcoming
          listEventsUpcoming(),
        ],
      ),
    );
  }

  // Title current events
  Widget titleEvents(String title){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('$title',
              style: TextStyle(
                  color: Colors.orange[600],
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
            ),
            FlatButton(
              child: Text(
                "Show All",
                style: TextStyle(
                    color: Colors.orange[600], fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShowAllEventsPage(uid: uid)));
              },
            ),
          ]),
    );
  }

  // list events occurring
  Widget listEventsCurrent(){
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 220.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: FutureBuilder<List<EventsDTO>>(
          // get count user register events
            future: EventsVM.getAllListEvents() ,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(0,12,0,0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.grey[200], width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)), // set rounded corner radius
                    ),
                    child : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context,snap){
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Column(
                            children: <Widget>[
                              getListEvents(snapshot, snap, 250.0, 160.0,snapshot.data[snap].id),
                              Text(snapshot.data[snap].title,style: TextStyle(fontSize: 19),),
                              Text(dtf.format(DateTime.parse(snapshot.data[snap].startedAt))),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                };
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                // loading when not found
                child: Center(child: CircularProgressIndicator()),
              );
            }));
  }

  // list event upcoming
  Widget listEventsUpcoming(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*1.4,
      child: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16),
        child: FutureBuilder<List<EventsDTO>>(
            future: EventsVM.getAllListEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    // get count user register events
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, snap) {
                      return Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          boxShadow: [BoxShadow(blurRadius: 9,color: Colors.grey[300],offset: Offset(0,3))]
                        ),
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              getListEvents(snapshot, snap, double.infinity, 160.0,snapshot.data[snap].id),
                              ListTile(
                                title: Text(snapshot.data[snap].title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),textAlign: TextAlign.start,),
                                subtitle: Text(dtf.format(DateTime.parse(snapshot.data[snap].startedAt)),style: TextStyle(fontSize: 16.0),),
                              ),
                            ],
                          ),
                      );
                    },
                  );
                };
              };
              return Padding(
                padding: const EdgeInsets.all(10.0),
                // loading when not found
                child: Center(
                    child: CircularProgressIndicator()),
              );
            }
        ),
      ),
    );
  }

  // show toast messasign login success
  showSmS(){
    if(status == null){
      Fluttertoast.cancel();
    }else{
      Fluttertoast.showToast(
          msg: status,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          fontSize: 24.0,
          textColor: Colors.black);
      sleep(Duration(seconds: 0));
    }
  }

  // get list events and flow
  getListEvents(snapshot,snap,width,height,id){
    return Center(
        child: status == null || status != "Người dùng đã đăng ký sự kiện" && snapshot.data[snap].id != idEvents
            ? new Padding(
          padding: const EdgeInsets.all(0.0),
          child: FlatButton(
            onPressed: () {
              // status ="Người dùng đăng ký sự kiện";
              status = null;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RegisterEventPage(
                      uid: uid, eventsDTO: snapshot.data[snap],count:snap+1,status:status,)));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset('assets/images/events${snap+1}.png',
                width: width, height: height, fit: BoxFit.cover,
              ),
            ),
          ),
        )
            : new Padding(
          padding: const EdgeInsets.all(0.0),
          child: FlatButton(
            onPressed: () => {
              for(int  i = 0;i < snapshot.data[snap].id; i++){
                if(snapshot.data[snap].id == idEvents){
                  status = 'Người dùng đã đăng ký sự kiện',
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterEventPage(uid: uid,
                          eventsDTO: snapshot.data[snap],
                          count: snap + 1, status: status,))),
                }else if(snapshot.data[snap].id != idEvents){
                  status = "Người dùng đăng ký sự kiện",
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RegisterEventPage(
                  uid: uid, eventsDTO: snapshot.data[snap],count:snap+1,status: status,))),
                }
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset('assets/images/events${snap+1}.png',
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
    );
  }
}