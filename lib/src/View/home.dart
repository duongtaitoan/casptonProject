import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
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

  const HomePage({Key key, this.uid, this.status,}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState(uid, status);
}

class _HomePageState extends State<HomePage> {
  final FirebaseUser uid;
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  var status;
  int selectedIndex = 0;
  var _tmpCheck = false;
  GlobalKey<ScaffoldState> _scaffoldKey;
  Widget _actionEvents = ActionEventsPage();
  EventsVM model;

  static List<EventsDTO> listEventDTO;
  static List<Widget> imageSliders;

  _HomePageState(this.uid, this.status);

  @override
  void initState() {
    handlerHoverImg();
    handlerShowMessage(this.status);
    _actionEvents = ActionEventsPage(uid: uid,);
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    super.initState();
    try {
      model = new EventsVM();
      model.getFirstIndex();
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
      return SingleChildScrollView(child:this.homeBody());
    } else if (this.selectedIndex == 1) {
      return this._actionEvents;
    } else {
      return HomeMenu(uid: uid);
    }
  }

  // appbar in show then show
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
                  titleEvents("On going events"),
                  _tmpCheck == true ? eventsHover(): Center(child: CircularProgressIndicator()),
                  titleEvents("Upcoming events"),
                  listEventsUpcoming(),
                ],
              )
          ),
        ),
      ],
    );
  }

  // screen hover
  Widget eventsHover(){
    return Column(
      children: <Widget>[
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                });
              }),
        ),
      ],
    );
  }

  // button search
  Widget IconSearch() {
    return Center(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 135,
          ),
          Text('Home'),
          SizedBox(
            width: 90,
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () =>
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowAllEventsPage(
                              uid: uid,
                            )),
                        (Route<dynamic> route) => false),
          ),
        ],
      ),
    );
  }

  // Title events
  Widget titleEvents(String title) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '$title',
              style: TextStyle(
                  color: Colors.orange[600],
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
            ),
            FlatButton(
              child: Text(
                "Show All",
                style: TextStyle(color: Colors.orange[600], fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShowAllEventsPage(uid: uid)));
              },
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
                    padding: const EdgeInsets.only(top:10),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegisterEventPage(uid: uid,
                                      idEvents: element.id,tracking:element.gpsTrackingRequired)));
                            },
                            child: ClipRRect(
                              child:Image.network('${element.thumbnailPicture}',width: double.infinity, height: 160.0, fit: BoxFit.cover,),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            element.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                            textAlign: TextAlign.start,
                          ),
                          subtitle: Text(
                            dtf.format(DateTime.parse(
                                element.startedAt)),
                            style: TextStyle(fontSize: 16.0),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(top:35.0,right: 4),
                            child: Text('Join now',style: TextStyle(fontSize: 16.0,),textAlign: TextAlign.end,),
                          ),
                        ),
                      ],
                    ),
                ));
              });
              // button load more
              return Column(
                children: [
                  ...list,
                  model.isAdd
                      ? Center(child: CircularProgressIndicator(),)
                      : FlatButton(
                     child: Center(
                        child: model.showToast == null ?Text("Load more"): Text("${model.showToast}"),
                    ),
                    onPressed: () async {
                      await model.changPageIndex();
                    },
                  )
                ],
              );
            }
            return Container();
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

  // check list events img on going
  handlerHoverImg() async {
    try {
      listEventDTO = await EventsVM.getEventsOnGoing();
      if (listEventDTO.isNotEmpty) {
        _tmpCheck = true;
        imageSliders = listEventDTO.map((item) =>
            Container(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.all(6),
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.grey[200], width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)), // set rounded corner radius
                    ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          InkWell (
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RegisterEventPage(
                                      uid: uid, idEvents: item.id, tracking:item.gpsTrackingRequired)));
                               });
                              },
                              child : Image.network('${item.thumbnailPicture}', fit: BoxFit.cover, width: 1000.0),),
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
                              child: Text(
                                '${limitName(item.title)}',
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
        setState(() { });
      } else {
        _tmpCheck = false;
        await Future.delayed(Duration(seconds: 1), () => '1');
        Center(child: CircularProgressIndicator());
      }
    }catch(e){
      handlerShowMessage("The system is waitting for an update");
    }
  }

  // limit name title of event
  limitName(String text){
    String firstHalf;
    if (text.length >= 20 && text != null) {
      firstHalf = text.substring(0, 20)+' ... ';
      return firstHalf;
    }else{
      return text;
    }
  }
}
