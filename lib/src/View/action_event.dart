import 'package:designui/src/Model/userDTO.dart';
import 'package:designui/src/ViewModel/events_viewmodel.dart';
import 'package:designui/src/ViewModel/history_viewmodel.dart';
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
  _ActionEventsPageState createState() => _ActionEventsPageState(uid);
}

class _ActionEventsPageState extends State<ActionEventsPage> with SingleTickerProviderStateMixin {
  final FirebaseUser uid;
  TabController _tabController;
  List<UserDTO> _search;
  HistoryVM historyVM;
  _ActionEventsPageState(this.uid);
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    historyVM = new HistoryVM();
    _tabController = new TabController(length: 4, vsync: this);
    _search = List<UserDTO>();
    super.initState();
  }

  // tabbar and body
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
          child: DefaultTabController(
            length: 4,
            child: Scaffold(
              backgroundColor: Colors.orange[600],
              appBar: TabBar(
                controller: _tabController,
                indicatorWeight: 4,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(icon: new Icon(Icons.history, ),
                    child: Text('Waiting',style: TextStyle(color: Colors.white),),),
                  Tab(icon: new Icon(Icons.check_circle_outline, ),
                        child:Text('Approve',style: TextStyle(color: Colors.white))),
                  Tab(icon: new Icon(Icons.insert_invitation,),
                    child: Text('On going',style: TextStyle(color: Colors.white),),),
                  Tab(icon: new Icon(Icons.cancel, ),
                    child: Text('Reject',style: TextStyle(color: Colors.white),),),
                ],
              ),
              body: new TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    tabTable("Waiting","Pending"),
                    tabTable("Approved","Accepted"),
                    // trạng thái on going chưa có đợi api trả về rồi tính
                    tabTable("On Going",""),
                    tabTable("Reject","Denied"),
                  ]
              ),
            ),
          ),
        )
    );
  }

  // button tab table
  Widget tabTable(String statusTitle, String flowStatus){
    return Container(
      width: double.infinity,
      height: 600,
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            getEvent(context, uid, statusTitle, _search, _controller,flowStatus),
          ],
        ),
      ),
    );
  }

  // list events flow status
  Widget getEvent(BuildContext context, uid, status, List<UserDTO> _search, _controller,flowStatus) {
    DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
        child: FutureBuilder<List<UserDTO>>(
          // get status of user and show
            future: historyVM.getFlowStatus(flowStatus),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
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
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10,),
                            getListEvents(snapshot, snap, double.infinity, 160.0,status),
                            ListTile(
                              title: Text(snapshot.data[snap].eventTitle,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),textAlign: TextAlign.start,
                              ),
                              subtitle: Text(dtf.format(DateTime.parse(snapshot.data[snap].startDate)),style: TextStyle(fontSize: 16.0),),
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
                child: Center(child: CircularProgressIndicator()),);
            }),
      ),
    );
  }

  // click events to screen register
  getListEvents(snapshot,snap,width,height,status){
    return Center(
      child:  new Padding(
        padding: const EdgeInsets.all(0.0),
        child: FlatButton(
          onPressed: () {
                 Navigator.of(context).push(
                     MaterialPageRoute(
                         builder: (context) =>
                             RegisterEventPage(uid: uid,
                               idEvents: snapshot.data[snap].id,
                               status: status,
                             )));
          },
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(15.0),
            child: Image.network('${snapshot.data[snap].thumbnailPicture}',
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
