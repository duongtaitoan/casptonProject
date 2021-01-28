import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:designui/src/Helper/notification.dart';
import 'package:designui/src/Helper/show_message.dart';
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
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser uid;
  final status;
  final barSelect;
  final pageIndex;
  const HomePage({Key key, this.uid, this.status,this.barSelect,this.pageIndex}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState(uid, status,barSelect,pageIndex);
}

class _HomePageState extends State<HomePage> {
  final FirebaseUser uid;
  final barSelect;
  final pageIndex;
  var status;
  var _tmpCheck = false;
  var _tmpCheckEvent = false;
  var _tmpCheckOngoing = false;
  var _tmpCheckOngoinEvent = false;
  var _tmpOpening = false;
  var _tmpOpeningEvent = false;
  DateFormat dtf = DateFormat('HH:mm a dd/MM/yyyy');
  int selectedIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldKey;
  Widget _actionEvents = ActionEventsPage();
  EventsVM model;

  static List<EventsDTO> listEventDTO;
  static List<Widget> imageSliders1;
  static List<EventsDTO> listEventOngoingDTO;
  static List<Widget> imageSliders2;
  static List<EventsDTO> listEventOpening;
  static List<Widget> imageSliders3;

  _HomePageState(this.uid, this.status,this.barSelect,this.pageIndex);

  @override
  void initState() {
    super.initState();

    NotificationEvent().configOneSignal(uid,context);
    handlerShowMessage(this.status);
    _actionEvents = ActionEventsPage(uid: uid,intIndexPage: pageIndex,);
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    if(barSelect != null){
      selectedIndex = barSelect;
    }
    try {
      setState(() {
        handlerHoverImg(1);
        handlerHoverImg(2);
        handlerHoverImg(3);
        model = new EventsVM();
        model.getFirstIndex();
      });
    }catch(e){
      handlerShowMessage("No Internet connection");
    }
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  // home bar
  void onItemTapped(int index) async {
    setState(() {
      selectedIndex = index;
    });
  }

  // body
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
              selectedIconTheme: IconThemeData(opacity: 1.0, size: 25),
              unselectedIconTheme: IconThemeData(opacity: 0.5, size: 20),
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home, color: Colors.white),
                  title: new Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.event,
                    color: Colors.white,
                  ),
                  title: new Text(
                    'Registered',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person, color: Colors.white),
                    title: Text(
                      'Profile',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
            body:  screenHome(),
          ),
        ));
  }

  // show body in home when user click
  Widget screenHome() {
    if (this.selectedIndex == 0) {
      setState(() { });
      return SingleChildScrollView(child:this.homeBody());
    } else if (this.selectedIndex == 1) {
      return this._actionEvents;
    } else {
      return HomeMenu(uid: uid);
    }
  }

  // show appbar if home
  Widget myAppBar() {
    if (this.selectedIndex == 0) {
      return AppBar(
        title: IconSearch(),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange[600],
      );
    } else if (this.selectedIndex == 1) {
      return null;
    } else {
      return null;
    }
  }

  // body home
  Widget homeBody() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[200],
          child: Center(
              child: Column(
                children: <Widget>[
                  _tmpCheckEvent == true
                      ?(Column(children: <Widget>[
                        titleEvents("This Week"),
                        eventsHover(1),
                      ],)) :Center(),
                  _tmpCheckOngoinEvent == true
                      ?(Column(children: <Widget>[
                    titleEvents("On Going"),
                    eventsHover(2),
                  ],)) :Center(),
                  _tmpOpeningEvent == true
                      ?(Column(children: <Widget>[
                    titleEvents("Opening"),
                    eventsHoverOpening(3),
                  ],)) :Center(),
                  titleEvents("Upcoming"),
                  listEventsUpcoming(),
                ],
              )
          ),
        ),
      ],
    );
  }

  // screen hover
  Widget eventsHover(int sequences){
    return Column(
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            CarouselSlider(
              items: sequences == 1 ? imageSliders1 : imageSliders2,
              // items: imageSliders1,
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {});
                  }),
            ),
          ],
        ),
      ],
    );
  }
  // screen hover
  Widget eventsHoverOpening(int sequences){
    return Column(
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            CarouselSlider(
              items: imageSliders3,
              // items: imageSliders1,
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {});
                  }),
            ),
          ],
        ),
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
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => ShowAllEventsPage(uid: uid,)), (Route<dynamic> route) => false),
          ),
        ],
      ),
    );
  }

  // Title events
  Widget titleEvents(String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('$title', style: TextStyle(
              color: Colors.orange[600],
              fontSize: 21,
              fontWeight: FontWeight.bold),
            ),
          ]),
    );
  }

  // list event upcoming
  Widget listEventsUpcoming() {
      return ScopedModel(
        model: model,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ScopedModelDescendant<EventsVM>(
            builder: (context, child, model) {
              if (model.isLoading) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (model.listEvent != null && model.listEvent.isNotEmpty) {
                List<Widget> list = List();
                model.listEvent.forEach((element) {
                list.add(Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 9,
                              color: Colors.grey[300],
                              offset: Offset(0, 3))
                        ]
                    ),
                    padding: const EdgeInsets.only(top:0),
                    child: Column(
                        children:<Widget>[
                          Container(
                              width: double.infinity,
                              height: 160,
                              child: Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: element.thumbnailPicture == null
                                        ? Center(child: new Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        new CircularProgressIndicator(),
                                        new Text("Loading"),
                                      ],),)
                                        :Image.network('${element.thumbnailPicture}',width: double.infinity, height: 160.0, fit: BoxFit.cover,),
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {
                                      setState(() {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => RegisterEventPage(
                                                uid: uid, idEvents: element.id, tracking:element.gpsTrackingRequired,nameLocation:element.location)));
                                      });
                                    },
                                  ),
                                ],
                              )),
                          ListTile(
                            title: Text(element.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                              textAlign: TextAlign.start,
                            ),
                            subtitle: Text(
                              dtf.format(DateTime.parse(element.startTime)),
                              style: TextStyle(fontSize: 16.0),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(top:35.0),
                              child: FlatButton(
                                onPressed: (){
                                  setState(() {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => RegisterEventPage(
                                            uid: uid, idEvents: element.id, tracking:element.gpsTrackingRequired,nameLocation:element.location)));
                                  });
                                },
                                child:Text('Join now',style: TextStyle(fontSize: 16.0,),textAlign: TextAlign.end,),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ));
                });
                // button load more
                return Column(
                  children: [
                    ...list,
                    model.isAdd
                        ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center (child: CircularProgressIndicator(),),
                    )
                        : FlatButton(
                      child: Center(
                        child: model.showToast == null
                            ? Text("Load more",style: TextStyle(fontSize: 18.0,color: Colors.orange[600]),)
                            : Text("${model.showToast}",style: TextStyle(fontSize: 18.0,color: Colors.orange[600]),),
                      ),
                      onPressed: () async {
                        await model.changPageIndex();
                      },
                    )
                  ],
                );
              }
              return Container(child: Text("${"No events opening"}",style: TextStyle(fontSize: 18.0,color: Colors.orange[600]),));
            },
          ),
        ),
      );
  }

  // show toast messasign login success
  handlerShowMessage(status) {
    if (status == null) {
      Fluttertoast.cancel();
    } else {
      ShowMessage.functionShowMessage(status);
    }
  }

  // check list events in week and ongoing
  handlerHoverImg(int sequences) async {
    try {
        // load event in week
        if(sequences == 1) {
          DateTime now =  new DateTime.now();
          var _tmpFuture = now.add(Duration(days: 7));
          listEventDTO = await EventsVM.eventInWeek(now.toUtc().toIso8601String(), _tmpFuture.toUtc().toIso8601String());
          eventByDayOrStatus(1);
          // event ongoing when user register event successful
        }else if(sequences == 2){
          listEventOngoingDTO = await EventsVM.getEventsOngoing();
          eventByDayOrStatus(2);
        }else if(sequences == 3){
          listEventOpening = await EventsVM.getListEventsOpening();
          eventByDayOrStatus(3);
        }
        setState((){});
    }catch(e){
      _tmpCheckEvent = false;
    }
  }

  // load data of event flow week and status
  eventByDayOrStatus(int id){
    if(id == 1) {
      if (listEventDTO.isNotEmpty) {
          _tmpCheck = true;
          _tmpCheckEvent = true;
          imageSliders1 = listEventDTO.map((item) =>
              Container(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.all(6),
                  padding: EdgeInsets.all(3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[200], width: 1),
                    borderRadius: BorderRadius.all(
                        Radius.circular(15.0)), // set rounded corner radius
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        RegisterEventPage(
                                            uid: uid,
                                            idEvents: item.id,
                                            tracking: item.gpsTrackingRequired,
                                            nameLocation: item.location)));
                              });
                            },
                            child: item.thumbnailPicture == null
                                ? Center(child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                new CircularProgressIndicator(),
                                new Text("Loading"),
                              ],),)
                                : Image.network(
                                '${item.thumbnailPicture}', fit: BoxFit.cover,
                                width: 1000.0),),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(0, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              // child: Text('${String.fromCharCode(ShowMessage.functionLimitCharacter(item.title).runes.first)}',
                              child: Text('${item.title}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              )).toList();
          setState(() {});
      } else if (listEventDTO.isNotEmpty) {
        _tmpCheck = false;
        _tmpCheckEvent = false;
        Center(
          child: CircularProgressIndicator(),
        );
      }
    }
    else if( id == 2){
      if (listEventOngoingDTO.isNotEmpty) {
        _tmpCheckOngoing = true;
        _tmpCheckOngoinEvent = true;
        imageSliders2 = listEventOngoingDTO.map((item) =>
            Container(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.all(3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(color: Colors.grey[200], width: 1),
                  borderRadius: BorderRadius.all(
                      Radius.circular(15.0)), // set rounded corner radius
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterEventPage(
                                          uid: uid,
                                          idEvents: item.id,
                                          tracking: item.gpsTrackingRequired,
                                          nameLocation: item.location)));
                            });
                          },
                          child: item.thumbnailPicture == null
                              ? Center(child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              new CircularProgressIndicator(),
                              new Text("Loading"),
                            ],),)
                              : Image.network(
                              '${item.thumbnailPicture}', fit: BoxFit.cover,
                              width: 1000.0),),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(0, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text('${item.title}',
                            // child: Text('${String.fromCharCode(ShowMessage.functionLimitCharacter(item.title).runes.first)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            )).toList();
        setState(() {});
      } else if (listEventOngoingDTO.isEmpty) {
        _tmpCheckOngoing = false;
        _tmpCheckOngoinEvent = false;
        Center(
          child: CircularProgressIndicator(),
        );
      }
    }else if( id == 3){
      if (listEventOpening.isNotEmpty) {
        _tmpOpening = true;
        _tmpOpeningEvent = true;
        imageSliders3 = listEventOpening.map((item) =>
            Container(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.all(3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(color: Colors.grey[200], width: 1),
                  borderRadius: BorderRadius.all(
                      Radius.circular(15.0)), // set rounded corner radius
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterEventPage(
                                          uid: uid,
                                          idEvents: item.id,
                                          tracking: item.gpsTrackingRequired,
                                          nameLocation: item.location)));
                            });
                          },
                          child: item.thumbnailPicture == null
                              ? Center(child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              new CircularProgressIndicator(),
                              new Text("Loading"),
                            ],),)
                              : Image.network(
                              '${item.thumbnailPicture}', fit: BoxFit.cover,
                              width: 1000.0),),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(0, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text('${item.title}',
                            // child: Text('${String.fromCharCode(ShowMessage.functionLimitCharacter(item.title).runes.first)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            )).toList();
        setState(() {});
      } else if (listEventOpening.isEmpty) {
        _tmpOpening = false;
        _tmpOpeningEvent = false;
        Center(
          child: CircularProgressIndicator(),
        );
      }
    }
  }
}
