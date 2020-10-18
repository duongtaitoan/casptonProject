import 'dart:async';
import 'dart:ui';
import 'package:designui/src/Helper/test_showdialog.dart';
import 'package:designui/src/view/menu.dart';
import 'package:designui/src/view/registers_event.dart';
import 'package:designui/src/view/view_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser uid;
  final int changeValue;

  const HomePage({
    Key key,
    this.uid,
    this.changeValue,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(uid, changeValue);
}

class _HomePageState extends State<HomePage> {

  final FirebaseUser uid;
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  var timeStart = "14:07 18/10/2020";
  var timeStop = "21:30 18/10/2020";
  int changeValue;
  var clock;

  _HomePageState(this.uid, this.changeValue);

  @override
  void initState() {
    final DateTime now = DateTime.now();
    print('now :' + now.toString());
    clock = Stream<DateTime>.periodic(const Duration(seconds: 1), (_) {
      return DateTime.now();
    });
    super.initState();
  }


  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var _scaffoldKey = new GlobalKey<ScaffoldState>();
    return SafeArea(
        child: SizedBox.expand(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: searchBar(),
              backgroundColor: Colors.amberAccent[400],
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

  Widget getListEvent() {
    var count = 0;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 620,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            height: 1,
            child: timeCheck(),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: const EdgeInsets.fromLTRB(20, 0, 7, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Sự kiện sắp diễn ra ",
                    style: TextStyle(
                        color: Colors.amberAccent[400],
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                  ),
                  FlatButton(
                    child: Text(
                      "Hiện tất cả",
                      style: TextStyle(
                          color: Colors.amberAccent[400], fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowAllEventsPage(uid: uid)));
                    },
                  ),
                ]),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: ListView.builder(
                  // get count user register events
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    count = index + 1;
                    return Container(
                      margin: EdgeInsets.all(6),
                      padding: EdgeInsets.all(3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(color: Colors.grey[200], width: 1),
                        borderRadius: BorderRadius.all(
                            Radius.circular(15.0)), // set rounded corner radius
                      ),
                      child: new ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: changeValue == null
                                  ? new Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterEventPage(
                                                          uid: uid,
                                                          count: index + 1)));
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.asset(
                                            'assets/images/events$count.png',
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
                                        // onPressed: () {
                                        //   showAlertDialog(
                                        //       context, timeStart, timeStop);
                                        // },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.asset(
                                            'assets/images/events$count.png',
                                            width: 140,
                                            height: 140,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            Text('title: event $count', ),
                            Text('dd/mm/yyyy'),
                          ],
                        ),
                      ),
                    );
                  })),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: const EdgeInsets.fromLTRB(20, 0, 7, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Sự kiện nổi bật",
                    style: TextStyle(
                        color: Colors.amberAccent[400],
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                  ),
                  FlatButton(
                    child: Text(
                      "Hiện tất cả",
                      style: TextStyle(
                          color: Colors.amberAccent[400], fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowAllEventsPage(uid: uid)));
                    },
                  ),
                ]),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 530,
            child: ListView.builder(
              // get count user register events
              itemCount: 10,
              itemBuilder: (context, index) {
                count = index + 1;
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
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RegisterEventPage(
                                                              uid: uid,
                                                              count:
                                                                  index + 1)));
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: Image.asset(
                                                'assets/images/events$count.png',
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
                                            // onPressed: () => showAlertDialog(
                                            //   context,
                                            //   timeStart,
                                            //   timeStop,
                                            // ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: Image.asset(
                                                'assets/images/events$count.png',
                                                width: 140,
                                                height: 140,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 170,
                                      height: 80,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 10),
                                      child: Text(
                                        'events do nhà trường tổ chức theo thứ tự $count',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 30,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 20),
                                      child: Text(
                                        'dd/mm/yyy',
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ])
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


   timeCheck()  {
    final now = DateTime.now();
    if (now.isAfter(dtf.parse(timeStart)) && now.isBefore(dtf.parse(timeStop))) {
      testShowAlertDialog(context,uid);
      // _showMyDialog(context);
    }
  }
}


