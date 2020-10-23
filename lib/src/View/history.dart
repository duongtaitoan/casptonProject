import 'package:designui/src/view/home.dart';
import 'package:designui/src/view/registers_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final FirebaseUser uid;
  const HistoryPage({Key key, this.uid}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState(uid);
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseUser uid;
  _HistoryPageState(this.uid);
  final int count = 10;

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child:SizedBox.expand(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Lịch sử'),
              backgroundColor: Colors.orange[400],
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>
                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> HomePage(uid: uid,)), (Route<dynamic> route) => false),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 10,
                  fit: FlexFit.tight,
                  child: Container(
                    width: double.infinity,
                    height: 600,
                    color: Colors.grey[100],
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          getEvent(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
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
            hintText: 'Tìm kiếm lịch sử sự kiện',
            hintStyle: TextStyle(color: Colors.grey)),
        onFieldSubmitted: (String input) {}),
  );
}

Widget getEvent() {
  var count = 0;
  return Container(
    width: double.infinity,
    height: 620,
    color: Colors.white,
    child: ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        SizedBox(
          height: 3,
        ),
        Container(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: searchBar(),
          ),
        ),
        SizedBox(height: 3),
        Container(
          height: 40,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(
                    "Lịch sử tham gia sự kiện",
                    style: TextStyle(
                        color: Colors.orange[400],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
        ),
        Container(
          height: 525,
          child: ListView.builder(
            // get count user register events
            itemCount: 10,
            itemBuilder: (context, index) {
              count = index + 1;
              return Container(
                child: FlatButton(
                  child: Container(
                    margin: EdgeInsets.all(5),
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
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
      ],
    ),
  );
}
