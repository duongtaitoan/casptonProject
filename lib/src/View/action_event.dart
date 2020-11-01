import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/ViewModel/events_viewmodel.dart';
import 'package:designui/src/view/registers_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActionEventsPage extends StatefulWidget {
  final FirebaseUser uid;
  final status;

  const ActionEventsPage({Key key, this.uid, this.status}) : super(key: key);

  @override
  _ActionEventsPageState createState() => _ActionEventsPageState(uid, status);
}

class _ActionEventsPageState extends State<ActionEventsPage> with SingleTickerProviderStateMixin {
  final FirebaseUser uid;
  final status;
  TabController _tabController;

  _ActionEventsPageState(this.uid, this.status);

  List<EventsDTO> _search;
  final TextEditingController _controller = TextEditingController();
  EventsVM vmDao;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    _search = List<EventsDTO>();
    vmDao = new EventsVM();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: TabBar(
                controller: _tabController,
                indicatorWeight: 4,
                indicatorColor: Colors.orange[600],
                tabs: [
                  Tab(icon: new Icon(Icons.history, color: Colors.orange[600],),),
                  Tab(icon: new Icon(Icons.event, color: Colors.orange[600],),),
                ],
              ),
              body: new TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Column(
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  getEvent(context, uid, status, _search,
                                      _controller),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  getEvent(context, uid, status, _search,
                                      _controller),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ));
  }


  Widget getEvent(BuildContext context, uid, status, List<EventsDTO> _search,
      _controller) {
    DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<List<EventsDTO>>(
          future: EventsVM.getAllListEvents(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return ListView.builder(
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
              child: Center(child: CircularProgressIndicator()),
            );
          }),
    );
  }

  getListEvents(snapshot,snap,width,height){
    var status = "Lịch sử người dùng";
    return Center(
      child:  new Padding(
        padding: const EdgeInsets.all(0.0),
        child: FlatButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        RegisterEventPage(
                          uid: uid,
                          eventsDTO: snapshot
                              .data[snap],
                          count: snap + 1,
                          status: status,
                        )));
          },
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(15.0),
            child: Image.asset(
              'assets/images/events${snap +
                  1}.png',
              width: double.infinity,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
        ),
      )
    );
  }
}