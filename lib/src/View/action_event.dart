import 'package:designui/src/Model/userDTO.dart';
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
  static DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');

  @override
  void initState() {
    historyVM = new HistoryVM();
    _tabController = new TabController(length: 3, vsync: this);
    _search = List<UserDTO>();
    super.initState();
  }

  // tabbar and body
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.orange[600],
              appBar: TabBar(
                controller: _tabController,
                indicatorWeight: 3,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(icon: new Icon(Icons.history, ),
                    child: Text('Waiting',style: TextStyle(color: Colors.white),),),
                  Tab(icon: new Icon(Icons.check_circle_outline, ),
                        child:Text('Approved',style: TextStyle(color: Colors.white))),
                  Tab(icon: new Icon(Icons.cancel, ),
                    child: Text('Rejected',style: TextStyle(color: Colors.white),),),
                ],
              ),
              body: new TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    tabTable("PENDING"),
                    tabTable("ACCEPTED"),
                    tabTable("REJECTED"),
                  ]
              ),
            ),
          ),
        )
    );
  }

  // button tab table
  Widget tabTable( String flowStatus){
    return Container(
      width: double.infinity,
      height: 600,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            getListEvents(context, uid, _search, _controller,flowStatus),
          ],
        ),
      ),
    );
  }

  // list events flow status registered of user
  Widget getListEvents(BuildContext context, uid, List<UserDTO> _search, _controller,flowStatus) {
    var _tmpChange = "";
    historyVM.getFlowStatus(flowStatus).then((value) {
      if(value == null){
        if(flowStatus.toString().compareTo("PENDING")==0){
          _tmpChange = "No waiting events";
        }else if(flowStatus.toString().compareTo("ACCEPTED")==0){
          _tmpChange = "No approved events";
        }else if(flowStatus.toString().compareTo("REJECTED")==0){
          _tmpChange = "No rejected events";
        };
      }
    });
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
        child: FutureBuilder(
            future: Future.delayed(Duration(seconds: 1)),
            builder: (c, s) => s.connectionState == ConnectionState.done
              ?  FutureBuilder<List<UserDTO>>(
                  future: historyVM.getFlowStatus(flowStatus),
                  builder: (context, snapshot) {
                    try{
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          if (snapshot.data.length == 0){
                            if(flowStatus.toString().compareTo("PENDING")==0){
                              _tmpChange = "No waiting events";
                            }else if(flowStatus.toString().compareTo("ACCEPTED")==0){
                              _tmpChange = "No approved events";
                            }else if(flowStatus.toString().compareTo("REJECTED")==0){
                              _tmpChange = "No rejected events";
                            }
                          }else {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, snap) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(blurRadius: 9,
                                            color: Colors.grey[300],
                                            offset: Offset(0, 3))
                                      ]
                                  ),
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 10,),
                                      Center(
                                          child: new Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegisterEventPage(
                                                              uid: uid,
                                                              idEvents: snapshot
                                                                  .data[snap]
                                                                  .eventId,)));
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(15.0),
                                                child: snapshot.data[snap].thumbnailPicture == null
                                                    ? Container(
                                                      width: double.infinity, height: 140,
                                                      child: Center(child: new Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          new CircularProgressIndicator(),
                                                          new Text("Loading"),
                                                        ],),),
                                                    )
                                                    : Image.network('${snapshot.data[snap].thumbnailPicture}',
                                                      width: double.infinity, height: 140, fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                      ListTile(
                                        title: Text(snapshot.data[snap].eventTitle,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                          textAlign: TextAlign.start,
                                        ),
                                        subtitle: Text(dtf.format(DateTime.parse(
                                            snapshot.data[snap].startDate)),
                                          style: TextStyle(fontSize: 16.0),),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        }
                      }
                    }catch(ignoredException){
                    }
                  return Padding (
                    padding: const EdgeInsets.only(top:250),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(child: Text('${_tmpChange}',style: TextStyle(fontSize: 18.0,color: Colors.orange[600]),))
                      ],
                    ),
                  );
                })
              : Padding (
                  padding: const EdgeInsets.only(top:100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center (
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(image: AssetImage("assets/images/tenor.gif"),width: 300,height: 300,),
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
        ),
      ),
    );
  }
}

