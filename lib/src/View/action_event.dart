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
  final intIndexPage;
  const ActionEventsPage({Key key, this.uid, this.status,this.intIndexPage}) : super(key: key);

  @override
  _ActionEventsPageState createState() => _ActionEventsPageState(uid,intIndexPage);
}

class _ActionEventsPageState extends State<ActionEventsPage> with SingleTickerProviderStateMixin {
  final FirebaseUser uid;
  final intIndexPage;
  TabController _tabController;
  List<UserDTO> _search;
  HistoryVM historyVM;
  _ActionEventsPageState(this.uid,this.intIndexPage);
  final TextEditingController _controller = TextEditingController();
  static DateFormat dtf = DateFormat('HH:mm a dd/MM/yyyy');


  @override
  void initState() {
    historyVM = new HistoryVM();
    if(intIndexPage == null){
      _tabController = new TabController(initialIndex: 0,length: 4, vsync: this);
    }else{
      _tabController = new TabController(initialIndex: intIndexPage,length: 4, vsync: this);
    }
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
                labelPadding: EdgeInsets.symmetric(horizontal: 2.0),
                indicatorColor: Colors.white,
                tabs: [
                  Tab(icon: new Icon(Icons.access_time, ),
                    child: Text('Waiting',style: TextStyle(color: Colors.white),),),
                  Tab(icon: new Icon(Icons.check_circle_outline, ),
                        child:Text('Approved',style: TextStyle(color: Colors.white))),
                  Tab(icon: new Icon(Icons.cancel, ),
                    child: Text('Rejected',style: TextStyle(color: Colors.white),),),
                  Tab(icon: new Icon(Icons.history, ),
                    child: Text('Checked in',style: TextStyle(color: Colors.white),),),
                ],
              ),
              body: new TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    tabTable("WAITING_FOR_APPROVAL"),
                    tabTable("APPROVED"),
                    tabTable("REJECTED"),
                    tabTable("CHECKED_IN"),
                  ]
              ),
            ),
          ),
        )
    );
  }

  // button tab table
  Widget tabTable(String flowStatus){
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
        if(flowStatus.toString().compareTo("WAITING_FOR_APPROVAL")==0 ||
            flowStatus.toString().compareTo("IN_WISHLIST")==0){
          _tmpChange = "No waiting registration";
        }else if(flowStatus.toString().compareTo("APPROVED")==0){
          _tmpChange = "No approved registration";
        }else if(flowStatus.toString().compareTo("REJECTED")==0){
          _tmpChange = "No rejected registration";
        }else if(flowStatus.toString().compareTo("CHECKED_IN")==0){
          _tmpChange = "No check in registration";
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
                            if(flowStatus.toString().compareTo("WAITING_FOR_APPROVAL")==0 ||
                                flowStatus.toString().compareTo("IN_WISHLIST")==0){
                              _tmpChange = "No waiting registration";
                            }else if(flowStatus.toString().compareTo("APPROVED")==0){
                              _tmpChange = "No approved registration";
                            }else if(flowStatus.toString().compareTo("REJECTED")==0){
                              _tmpChange = "No rejected registration";
                            }else if(flowStatus.toString().compareTo("CHECKED_IN")==0){
                              _tmpChange = "No check in registration";
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
                                      border: Border.all(color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                      boxShadow: [BoxShadow(blurRadius: 9,
                                            color: Colors.grey[300],
                                            offset: Offset(0, 3))]),
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          width: double.infinity,
                                          height: 150,
                                          child: Stack(
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child:
                                                // snapshot.data[snap].eventThumbnail == null
                                                //     ? Center(child: new Column(
                                                //   mainAxisSize: MainAxisSize.min,
                                                //   children: [
                                                //     new CircularProgressIndicator(),
                                                //     new Text("Loading"),
                                                //   ],),)
                                                //     :
                                                Image.network('${snapshot.data[snap].eventThumbnail}',width: double.infinity, height: 200, fit: BoxFit.cover,),
                                                // Image.network('${snapshot.data[snap].eventThumbnail}',width: double.infinity, height: 200, fit: BoxFit.cover,),
                                              ),
                                              InkWell(
                                                borderRadius: BorderRadius.circular(10),
                                                onTap: () {
                                                  setState(() {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => RegisterEventPage(uid: uid,
                                                        idEvents: snapshot.data[snap].eventId,nameLocation: snapshot.data[snap].eventLocation,)));                                                  });
                                                },
                                              ),
                                            ],
                                          )),
                                      ListTile(
                                        title: Text(snapshot.data[snap].eventName, style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 18.0), textAlign: TextAlign.start,),
                                        subtitle: Text(dtf.format(DateTime.parse(snapshot.data[snap].eventEndTime)),
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

