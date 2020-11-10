import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/ViewModel/events_viewmodel.dart';
import 'package:designui/src/view/home.dart';
import 'package:designui/src/view/registers_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  final FirebaseUser uid;
  final status;

  const HistoryPage({Key key, this.uid, this.status}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState(uid, status);
}

class _HistoryPageState extends State<HistoryPage>{
  final FirebaseUser uid;
  final status;
  List<EventsDTO> _search;
  final TextEditingController _controller = TextEditingController();
  EventsVM vmDao;

  _HistoryPageState(this.uid, this.status);

  @override
  void initState() {
    _search = List<EventsDTO>();
    vmDao = new EventsVM();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Your History'),
                backgroundColor: Colors.orange[600],
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
              body:Column(
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: searchBar(searchEvents, _controller),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                getEvent(context, uid, status, _search, _controller),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
    ));
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

Widget searchBar(searchEvents, _controller) {
  return Material(
    elevation: 1.0,
    borderRadius: BorderRadius.circular(20.0),
    child: ListTile(
      leading: Icon(Icons.search, color: Colors.black),
      title: TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 25.0, top: 1.0),
            hintText: 'Search events',
            hintStyle: TextStyle(color: Colors.grey)),
        controller: _controller,
        onChanged: searchEvents,
      ),
      trailing: IconButton(
        onPressed: () {
          _controller.clear();
          searchEvents('');
        },
        icon: Icon(Icons.cancel, color: Colors.black),
      ),
    ),
  );
}

Widget getEvent(BuildContext context, uid, status, List<EventsDTO> _search, _controller) {
  var status = "This event you have completed";
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 570,
    child: FutureBuilder<List<EventsDTO>>(
        future: EventsVM.getAllListEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return _search.length != 0 || _controller.text.isNotEmpty
                  ? Center(
                    child:  _search.length != 0
                        ? ListView.builder(
                        itemCount: _search.length,
                        itemBuilder: (context, i) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.grey[200], width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: FlatButton(
                              child: Column(children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 6,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegisterEventPage(
                                                              uid: uid,
                                                              eventsDTO: _search[i],
                                                              count: _search[i].id,
                                                              status: status,
                                                            )));
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                child: Image.asset(
                                                  'assets/images/events${_search[i].id}.png',
                                                  width: double.infinity,
                                                  height: 140,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              _search[i].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0),
                                            ),
                                            Text(
                                              dtf.format(DateTime.parse(
                                                  _search[i].startedAt)),
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                            // lấy trạng thái user tham gia hay chưa tham gia (xanh) / hủy thì màu (đỏ) / in wishlist (cam)
                                            // status =="wishList" ? Center(
                                            //   child: status == "tham gia"|| status =="chưa tham gia"
                                            //       ? Text('',style: TextStyle(fontSize: 16.0,color: Colors.blue[500]),)
                                            //       : Text('',style: TextStyle(fontSize: 16.0,color: Colors.red[500])),)
                                            //     : Text('', style: TextStyle(fontSize: 16.0,color: Colors.orange[600]),),
                                          ],
                                        ),
                                      ),
                                    ])
                              ]),
                            ),
                          );
                        })
                        : Center(child: Text('Not found events',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),),
                  )
                  : ListView.builder(
                      // get count user register events
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, snap) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 6,
                                      child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
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
                                              'assets/images/events${snap + 1}.png',
                                              width: double.infinity,
                                              height: 140,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[snap].title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                          Text(
                                            dtf.format(DateTime.parse(
                                                snapshot.data[snap].startedAt)),
                                            style: TextStyle(fontSize: 16.0),
                                          ),
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
        }),
  );
}
