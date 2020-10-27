import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/ViewModel/events_viewmodel.dart';
import 'package:designui/src/view/home.dart';
import 'package:designui/src/view/registers_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowAllEventsPage extends StatefulWidget {
  final FirebaseUser uid;

  const ShowAllEventsPage({Key key, this.uid}) : super(key: key);

  @override
  _ShowAllEventsPageState createState() => _ShowAllEventsPageState(uid);
}

class _ShowAllEventsPageState extends State<ShowAllEventsPage> {
  final FirebaseUser uid;

  _ShowAllEventsPageState(this.uid);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:SizedBox.expand(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Tất cả sự kiện'),
              backgroundColor: Colors.orange[400],
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                          uid: uid,
                        )),
                        (Route<dynamic> route) => false),
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
                    height: 620,
                    color: Colors.grey[100],
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10,),
                          searchBar(),
                          SizedBox(height: 10,),
                          getEvent(context,uid),
                        ],
                      ),
                    ),
                  ),
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

Widget getEvent(BuildContext context,uid) {
  var status ;
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 570,
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
                      child: Column(children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: Center(
                                    child: status == null || status != "Người dùng đã đăng ký sự kiện" ?
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 5,bottom: 5),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => RegisterEventPage(
                                                uid: uid, eventsDTO: snapshot.data[snap],count:snap + 1,status: status,)));},
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: Image.asset('assets/images/events${snap + 1}.png',
                                            width: double.infinity, height: 140, fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ): new Padding(
                                  padding: const EdgeInsets.all(0.0),
                                    child: FlatButton(
                                      onPressed: () => {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => RegisterEventPage(
                                                uid: uid, eventsDTO: snapshot.data[snap],
                                                count:snap+1,status:status))),
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
  );
}
