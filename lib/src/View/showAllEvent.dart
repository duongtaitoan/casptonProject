import 'package:designui/src/view/home.dart';
import 'package:designui/src/view/registerEvent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowAllEventsPage extends StatefulWidget {
  final FirebaseUser uid;
  const ShowAllEventsPage({Key key, this.uid}) : super(key: key);
  @override
  _ShowAllEventsPageState createState() => _ShowAllEventsPageState(uid);
}

class _ShowAllEventsPageState extends State<ShowAllEventsPage> {
  final FirebaseUser uid;
  _ShowAllEventsPageState(this.uid);
  final int count = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tất cả sự kiện'),
        backgroundColor: Colors.amberAccent[400],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> HomePage(uid: uid,)), (Route<dynamic> route) => false),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: searchBar(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child:Text(
                            "Sự kiện",
                            style: TextStyle(
                                color: Colors.amberAccent[400],
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                  getEvent(),
                  SizedBox(
                    height: 10,
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget searchBar() {
  return Material(
    elevation: 10.0,
    borderRadius: BorderRadius.circular(20.0),
    child: TextFormField(
        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search, color: Colors.black),
            contentPadding: EdgeInsets.only(left: 25.0, top: 15.0),
            hintText: 'Tìm kiếm sự kiện',
            hintStyle: TextStyle(color: Colors.grey)),
        onFieldSubmitted: (String input) {}),
  );
}

Widget getEvent() {
  var count = 0;
  return Container(
    width: double.infinity,
    height: 491,
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        child: ListView.builder(
          // get count user register events
          itemCount: 10,
          itemBuilder: (context, index) {
            count = index + 1;
            return Container(
              child: FlatButton(
                child: Container(
                  margin: EdgeInsets.all(7),
                  padding: EdgeInsets.all(3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[200], width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RegisterEventPage()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(
                              'assets/images/events$count.png',
                              width: 150,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: ListTile(
                          title: Text(
                          'events do nhà trường tổ chức theo thứ tự $count',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),
                        ),
                          subtitle: Text(
                            'dd/mm/yyy',
                            style: TextStyle(fontSize: 18.0),
                          ),
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
    ),
  );
}