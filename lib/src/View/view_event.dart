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
  List<EventsDTO> _search;
  TextEditingController _controller;
  EventsVM vmDao;
  GlobalKey<ScaffoldState> _scaffoldKey;
  _ShowAllEventsPageState(this.uid);

  @override
  void initState() {
    _search = List<EventsDTO>();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _controller = TextEditingController();
    vmDao = new EventsVM();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.circular(20.0),
              child:  ListTile(
                leading: Icon(Icons.search),
                title: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 1.0),
                      hintText: 'Tìm kiếm sự kiện',
                      hintStyle: TextStyle(color: Colors.grey)),
                  controller: _controller,
                  onChanged: searchEvents,
                ),
                trailing: IconButton(
                  onPressed: () {
                    _controller.clear();
                    _search.clear();
                    searchEvents('');
                  },
                  icon: Icon(Icons.cancel),
                ),
              )
            ),
            backgroundColor: Colors.orange[600],
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(uid: uid,)),
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
                  color: Colors.grey[100],
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        getEvent(context, uid, _search, _controller),
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

  searchEvents(String input) async{
    _search.clear();
    if (input.isEmpty) {
      setState(() {});
      return;
    }
    List<EventsDTO> tmpList = new List();
    List<EventsDTO> listEvents = await EventsVM.getAllListEvents();
    listEvents.forEach((ex) {
      if (ex.title.toUpperCase().contains(input.toUpperCase()) || ex.description.toString().contains(input.toUpperCase())) {
        tmpList.add(ex);

        for(int i = 0; i< tmpList.length; i++ ){
          if(ex.id.toString().compareTo(tmpList[i].id.toString()) == 0){
            _search.add(ex);
          }
        }
        setState(() {
          _search.clear();
          _search.addAll(tmpList);
        });
        return;
      } else if(!_search.isNotEmpty){
        _search.clear();
      }
    });
  }
}

Widget getEvent(BuildContext context, uid,List<EventsDTO> _search, _controller) {
  var status;
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  return Container(
    padding: const EdgeInsets.only(right: 10,top: 10),
    width: MediaQuery.of(context).size.width,
    height: 620,
    child: FutureBuilder<List<EventsDTO>>(
        future: EventsVM.getAllListEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return _search.length != 0 || _controller.text.isNotEmpty
                  ? ListView.builder(
                      itemCount: _search.length,
                      itemBuilder: (context, i) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[200], width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          child: FlatButton(
                            child: Column(children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 10,),
                                  getListEvents(_search[i], _search[i].id,status,context,uid ),
                                  ListTile(
                                    title: Text( _search[i].title, style:
                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),textAlign: TextAlign.start,),
                                    subtitle: Text(dtf.format(DateTime.parse(_search[i].startedAt)),style: TextStyle(fontSize: 16.0),),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                    );
                  })
                  : ListView.builder(
                      // get count user register events
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, snap) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.grey[200], width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          child: FlatButton(
                            child: Column(children: <Widget>[
                               Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 10,),
                                    getListEvents(snapshot, snap,status,context,uid ),
                                    ListTile(
                                      title: Text(snapshot.data[snap].title,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),textAlign: TextAlign.start,
                                      ),
                                      subtitle: Text(dtf.format(DateTime.parse(snapshot.data[snap].startedAt)),style: TextStyle(fontSize: 16.0),),
                                    ),
                                  ],
                                ),
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
        }),
  );
}

getListEvents(snapshot,snap,status,context,uid){
  return Center(
    child: status == null || status != "Người dùng đã đăng ký sự kiện"
        ? new Padding(
      padding: const EdgeInsets.all(0.0),
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RegisterEventPage(
                  uid: uid, eventsDTO: snapshot.data[snap],count:snap+1)));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset('assets/images/events${snap+1}.png',
            width: double.infinity,
            height: 170,
            fit: BoxFit.cover,
          ),
        ),
      ),
    )
        : new Padding(
      padding: const EdgeInsets.all(0.0),
      child: FlatButton(
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RegisterEventPage(
                  uid: uid, eventsDTO: snapshot.data[snap],count:snap+1,status:status))),
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset('assets/images/events${snap+1}.png',
            width: double.infinity,
            height: 170,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}
