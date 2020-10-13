import 'dart:ui';
import 'package:designui/src/view/menu.dart';
import 'package:designui/src/view/registerEvent.dart';
import 'package:designui/src/view/showAllEvent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser uid;

  const HomePage({Key key, this.uid}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(uid);
}

class _HomePageState extends State<HomePage> {
  final FirebaseUser uid;

  _HomePageState(this.uid);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _scaffoldKey = new GlobalKey<ScaffoldState>();
    return Scaffold(
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
      body: new SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 600,
                color: Colors.grey[100],
                child: Column(
                  children: <Widget>[
                    getListEvent(),
                  ],
                ),
              ),
            ],
          ),
      ),
      drawer: Drawer(
        child: HomeMenu(
          uid: uid,
        ),
      ),
    );
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
              hintText: 'Search for events',
              hintStyle: TextStyle(color: Colors.grey)),
          onFieldSubmitted: (String input) {

          }),
    );
  }

  Widget getListEvent() {
    var count = 0;
    return Container(
      width: double.infinity,
      height: 600,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.fromLTRB(20, 0, 7, 0),
            child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Sự kiện nổi bật ",
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
              width: double.infinity,
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
                        borderRadius: BorderRadius.all(
                            Radius.circular(15.0)), // set rounded corner radius
                      ),
                      child: new ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => RegisterEventPage(uid: uid,count:count)));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(
                                    'assets/images/events$count.png',
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Text('title: event $count'),
                            Text('dd/mm/yyyy'),
                          ],
                        ),
                      ),
                    );
                  })
          ),
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.fromLTRB(20, 0, 7, 0),
            child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Sự kiện sắp diễn ra",
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
              width: double.infinity,
              height: 530,
              child: ListView.builder(
                // get count user register events
                itemCount: 10,
                itemBuilder: (context, index) {
                  count = index + 1;
                  return Container(
                    margin: const EdgeInsets.fromLTRB(5.0,10.0,5.0 ,0.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200], width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    child: FlatButton(
                      child: Container(
                        margin: EdgeInsets.all(7),
                        padding: EdgeInsets.all(3),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                        ),

                        child: Column(children: <Widget>[
                          Row(children: <Widget>[
                            Expanded(
                              flex: 6,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => RegisterEventPage(uid: uid,count: count)));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset(
                                    'assets/images/events$count.png',
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
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
                                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      'events do nhà trường tổ chức theo thứ tự $count',
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),
                                    ),
                                  ),
                                 Container(
                                   width: double.infinity,
                                   height: 30,
                                   margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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
}
