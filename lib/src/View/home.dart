import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:designui/src/Helper/camera_plugin.dart';
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
    this.nameEvents, this.timeStart, this.timeStop, this.idEvents,this.status
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
  List<EventsDTO> _search;
  final TextEditingController _controller = TextEditingController();
  EventsVM vmDao;

  _HomePageState(this.uid, this.nameEvents, this.timeStart, this.timeStop, this.idEvents,this.status);
  GlobalKey<ScaffoldState> _scaffoldKey;
  Widget _actionEvents = ActionEventsPage();

  @override
  void initState() {
    checkStatus();
    _actionEvents = ActionEventsPage(uid: uid,);
    _search = List<EventsDTO>();
    vmDao = new EventsVM();
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
                  title: new Text('Hoạt động',style: TextStyle(color: Colors.white),),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person,color: Colors.white),
                    title: Text('Cá nhân',style: TextStyle(color: Colors.white),)
                )
              ],
            ),
            body: getBody(),
          ),
        ));
  }

  // show body in home when user click
  Widget getBody( )  {
    if(this.selectedIndex == 0) {
      return this.body();
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
  body(){
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
            color: Colors.grey[100],
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
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          // title of current events
          titleEvents("Sự kiện đang diễn ra"),
          // list events current
          listEventsCurrent(),
          // title events upcoming
          titleEvents("Sự kiện sắp diễn ra"),
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
                "Hiện tất cả",
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
        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: FutureBuilder<List<EventsDTO>>(
          // get count user register events
            future: EventsVM.getAllListEvents() ,
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
                    child : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context,snap){
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Column(
                            children: <Widget>[
                              getListEvents(snapshot, snap, 250.0, 160.0),
                              Text(snapshot.data[snap].title,style: TextStyle(fontSize: 19),),
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
            }));
  }

  // list event upcoming
  Widget listEventsUpcoming(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*1.88,
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
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          getListEvents(snapshot, snap, double.infinity, 160.0),
                          ListTile(
                            title: Text(snapshot.data[snap].title,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),textAlign: TextAlign.start,
                            ),
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
              child: Container(
                  width: 25,
                  height: 25,
                  padding: const EdgeInsets.only(bottom: 1200.0, left: 150,right: 150,top: 90),
                  child: CircularProgressIndicator()),
            );
          }
      ),
    );
  }

  // showdialog and goto checking
  showDiaLogLocation(BuildContext context) async {
      //   // notification get location for user
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Thông báo"),
            content: Text("Sự kiện $nameEvents đang diễn ra. Xin vui lòng đến trang sự kiện để check in"),
            actions: [
              CupertinoButton(
                child: Text('Đồng ý',style: TextStyle(color: Colors.blue[500]),),
                onPressed: () async {
                  checkLocation = true;
                  await Future.delayed(Duration.zero, () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (BuildContext context) => CameraApp(uid:uid,status:status,timeStart: timeStart,timeStop: timeStop,
                          nameEvents:nameEvents,idEvents:idEvents,)),(Route<dynamic> route) => false);
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
  }

  // check status
  checkStatus(){
    if(status == null){
      showSmS();
    }else if(status == "Người dùng đã đăng ký sự kiện") {
      var now = DateTime.now();
      Stopwatch s = new Stopwatch();
      Timer.periodic(Duration(seconds: 1), (Timer time) {
        if (now.isAfter(dtf.parse(timeStart)) && now.isBefore(dtf.parse(timeStop))) {
          showDiaLogLocation(context);
          s.stop();
          time.cancel();
        }
      });// showDiaLogLocation(context);
    }
    showSmS();
  }

  // show messasign when user login success
  showSmS(){
    if( status == null){
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

  // centerEvents
  getListEvents(snapshot,snap,width,height){
    return Center(
      child: status == null || status != "Người dùng đã đăng ký sự kiện"
          ? new Padding(
        padding: const EdgeInsets.all(0.0),
        child: FlatButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegisterEventPage(
                    uid: uid, eventsDTO: snapshot.data[snap],count:snap+1)));
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
          : new Padding(
        padding: const EdgeInsets.all(0.0),
        child: FlatButton(
          onPressed: () => {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegisterEventPage(
                    uid: uid, eventsDTO: snapshot.data[snap],count:snap+1,status:status))),
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
      ),
    );
  }
}