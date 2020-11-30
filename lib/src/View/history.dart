import 'dart:async';
import 'package:designui/src/Model/userDTO.dart';
import 'package:designui/src/ViewModel/history_viewmodel.dart';
import 'package:designui/src/view/home.dart';
import 'package:designui/src/view/registers_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class HistoryPage extends StatefulWidget {
  final FirebaseUser uid;

  const HistoryPage({Key key, this.uid,}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState(uid);
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseUser uid;
  List<UserDTO> _search;
  HistoryVM model;
  DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  var status = "This event you have completed";
  final TextEditingController _controller = TextEditingController();

  _HistoryPageState(this.uid,);

  @override
  void initState() {
    _search = List<UserDTO>();
    super.initState();
    try {
      model = new HistoryVM();
      model.pageFristHistory();
    } catch (e) {
    }
  }

  // body history
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
                onPressed: () =>
                    Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(
                        builder: (context) => HomePage(uid: uid,)),
                            (Route<dynamic> route) => false),
              ),
            ),
            body: SingleChildScrollView(
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
                  getEvent(context, uid, _search, _controller),
                ],
              ),
            ),
          ),
        )
    );
  }

  // search event flow title event => show for user
  searchEvents(String input) async {
    var delayInput = input;
    Future.delayed(new Duration(seconds: 2),()=>delayInput);
      _search.clear();
      if (delayInput.isEmpty) {
        setState(() {});
        return;
      }

      List<UserDTO> tmpList = new List();
      List<UserDTO> listEvents = await HistoryVM().getListEventHistory();

      listEvents.forEach((ex) {
        if (ex.eventTitle.toUpperCase().contains(delayInput.toUpperCase())) {
          tmpList.add(ex);

          for (int i = 0; i < tmpList.length; i++) {
            if (ex.id.toString().compareTo(tmpList[i].id.toString()) == 0) {
              _search.add(ex);
            }
          }
          setState(() {
            _search.clear();
            _search.addAll(tmpList);
          });
          return;
        } else if (!_search.isNotEmpty) {
          _search.clear();
        }
      });
  }

  // search bar flow events history
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
          onChanged: (textInput){
            if (textInput.length <= 0) {
              _controller.clear();
              searchEvents('');
            }
            searchEvents(textInput);
          } ,
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

  // event history
  Widget eventsHistory() {
    return ScopedModel(
      model: model,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: ScopedModelDescendant<HistoryVM>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (model.listEvent != null && model.listEvent.isNotEmpty) {
              List<Widget> list = List();
              model.listEvent.forEach((element) {
                list.add(Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10.0),),
                      boxShadow: [BoxShadow(blurRadius: 9,
                          color: Colors.grey[300], offset: Offset(0, 3))
                      ]),
                  child: FlatButton(
                    onPressed: () {Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RegisterEventPage(uid: uid,
                            idEvents: element.eventId, status: status)));
                    },
                    padding: const EdgeInsets.only(top: 1,left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network('${element.thumbnailPicture}',
                                        width: double.infinity, height: 140, fit: BoxFit.cover,),
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
                                    SizedBox(width: 10,),
                                    Text(limitTitle(element.eventTitle),
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                                    Text(dtf.format(DateTime.parse(element.startDate)),
                                      style: TextStyle(fontSize: 16.0),),
                                    element.status.toLowerCase() != "pending" ? Center(
                                      child: element.status.toLowerCase() == "accepted" || element.status.toLowerCase() != "canceled"
                                          ? Text('${element.status.toLowerCase()}', style: TextStyle(fontSize: 16.0,
                                            color: Colors.green[500]),)
                                          : Text('${element.status.toLowerCase()}', style: TextStyle(fontSize: 16.0,
                                              color: Colors.red[500])),)
                                          : Text('${element.status.toLowerCase()}', style: TextStyle(fontSize: 16.0,
                                          color: Colors.yellow[600]),),
                                  ],
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ));
              });
              // button load more
              return Column(
                children: [
                  ...list,
                  model.isAdd
                      ? Center(child: CircularProgressIndicator(),)
                      : FlatButton(
                    child: Center(
                      child: model.mgs == null
                          ? Text("load more events")
                          : Text("${model.mgs}"),
                    ),
                    onPressed: () async {
                      await model.pageHistoryIndex();
                    },
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  // respond list events of user
  Widget getEvent(BuildContext context, uid, List<UserDTO> _search, _controller) {
    var _tmpSMS ="Not found events";
    return SingleChildScrollView(
      child:  FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 1000)),
          builder: (c, s) => s.connectionState == ConnectionState.done
              ? FutureBuilder<List<UserDTO>>(
              future: HistoryVM().getListEventHistory(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    return _search.length != 0 || _controller.text.isNotEmpty
                        ? Center(child: _search.length != 0
                          ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _search.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0),),
                                    boxShadow: [BoxShadow(blurRadius: 9,
                                        color: Colors.grey[300],
                                        offset: Offset(0, 3))
                                    ]),
                                child: FlatButton(
                                  onPressed: () {Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>
                                          RegisterEventPage(uid: uid, idEvents: _search[i].eventId,
                                              status: status)));
                                  },
                                  padding: const EdgeInsets.only(top: 1,left: 10),
                                  child: Column(children: <Widget>[
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 5,
                                            child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                  child: ClipRRect(borderRadius:
                                                  BorderRadius.circular(15.0),
                                                    child: Image.network('${_search[i].thumbnailPicture}',
                                                      width: double.infinity, height: 140,
                                                      fit: BoxFit.cover,),
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
                                                SizedBox(width: 10,),
                                                Text(limitTitle(_search[i].eventTitle),
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                                                Text(dtf.format(DateTime.parse(_search[i].startDate)),
                                                  style: TextStyle(fontSize: 16.0),),
                                                _search[i].status.toLowerCase() != "pending" ? Center(
                                                  child: _search[i].status.toLowerCase() == "accepted" || _search[i].status.toLowerCase() != "canceled"
                                                      ? Text('${_search[i].status.toLowerCase()}', style: TextStyle(fontSize: 16.0,
                                                      color: Colors.green[500]),)
                                                      : Text('${_search[i].status.toLowerCase()}', style: TextStyle(fontSize: 16.0,
                                                      color: Colors.red[500])),)
                                                    : Text('${_search[i].status.toLowerCase()}', style: TextStyle(fontSize: 16.0,
                                                    color: Colors.yellow[600]),),
                                              ],
                                            ),
                                          ),
                                        ])
                                  ]),
                                ),
                              ),
                            );
                          })
                          : Center(child: Text('${_tmpSMS}', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),),)
                        : eventsHistory();
                  };
                }else if(snapshot.data == null){
                  _tmpSMS;
                }
                return Center(child: Text('${_tmpSMS}',style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),);
              })
              : Padding (
                padding: const EdgeInsets.only(top:200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Loading...'),
                  ],
                ),
          )
      )
    );
  }

  // limit name title of event
  limitTitle(String text) {
    String firstHalf;
    if (text.length >= 20 && text != null) {
      firstHalf = text.substring(0, 20) + ' ... ';
      return firstHalf;
    } else {
      return text;
    }
  }
}

