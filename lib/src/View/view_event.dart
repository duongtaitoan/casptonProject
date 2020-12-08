import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/ViewModel/all_event_viewmodel.dart';
import 'package:designui/src/ViewModel/events_viewmodel.dart';
import 'package:designui/src/view/home.dart';
import 'package:designui/src/view/registers_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

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
  ViewAllVM model;
  GlobalKey<ScaffoldState> _scaffoldKey;
  _ShowAllEventsPageState(this.uid);
  static DateFormat dtf = DateFormat('HH:mm dd/MM/yyyy');
  var checkSearch = false;

  @override
  void initState() {
    _search = List<EventsDTO>();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _controller = TextEditingController();
    vmDao = new EventsVM();
    super.initState();
    model = new ViewAllVM();
    model.pageFrist(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox.expand(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Material(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.orange[600],
                child: ListTile(
                  title: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 1.0),
                        hintText: 'Search events',
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 20.0)),
                    controller: _controller,
                    onChanged: (textInput) {
                      if (textInput.length <= 0) {
                        _controller.clear();
                        searchEvents('');
                      }else{
                        searchEvents(textInput);
                      }
                    },
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      _controller.clear();
                      _search.clear();
                      searchEvents('');
                    },
                    icon: Icon(Icons.cancel, color: Colors.white),
                  ),
                )),
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

  // search event flow title and content event => show for user
  searchEvents(String input) async {
    try {
      var delayInput = input;
      Future.delayed(new Duration(seconds: 2), () => delayInput);
      _search.clear();
      if (delayInput.isEmpty) {
        setState(() {});
        return;
      }

      List<EventsDTO> tmpList = new List();
      List<EventsDTO> listEvents = await EventsVM.getAllListEvents();

      listEvents.forEach((ex) {
        if (ex.title.toUpperCase().contains(delayInput.toUpperCase())) {
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
    }catch(e){

    }
  }

  Widget listEvents() {
    return SingleChildScrollView(
      child: ScopedModel(
        model: model,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ScopedModelDescendant<ViewAllVM>(
            builder: (context, child, model) {
              if (model.isLoading) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (model.listEvent != null &&
                  model.listEvent.isNotEmpty) {
                List<Widget> list = List();
                model.listEvent.forEach((element) {
                  list.add(Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 9,
                              color: Colors.grey[300],
                              offset: Offset(0, 3))
                        ]),
                    padding: const EdgeInsets.only(top: 0),
                    child: Column(children: <Widget>[
                      Container(
                          width: double.infinity,
                          height: 160,
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  '${element.thumbnailPicture}',
                                  width: double.infinity,
                                  height: 160.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  setState(() {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterEventPage(
                                                    uid: uid,
                                                    idEvents: element.id,
                                                    tracking: element
                                                        .gpsTrackingRequired)));
                                  });
                                },
                              ),
                            ],
                          )),
                      ListTile(
                        title: Text(
                          element.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                          textAlign: TextAlign.start,
                        ),
                        subtitle: Text(
                          dtf.format(DateTime.parse(element.startedAt)),
                          style: TextStyle(fontSize: 16.0),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(top: 35.0),
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RegisterEventPage(
                                        uid: uid,
                                        idEvents: element.id,
                                        tracking:
                                            element.gpsTrackingRequired)));
                              });
                            },
                            child: Text(
                              'Join now',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ));
                });
                // button load more
                return Column(
                  children: [
                    ...list,
                    model.isAdd
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : FlatButton(
                            child: Center(
                              child: model.mgs == null
                                  ? Text("Load more")
                                  : Text("${model.mgs}"),
                            ),
                            onPressed: () async {
                              await model.pageIndex();
                            },
                          )
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget getEvent(BuildContext context, uid, List<EventsDTO> _search, _controller) {
    var _tmpSMS = "Not found events";
    return SingleChildScrollView(
        child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 1000)),
            builder: (c, s) => s.connectionState == ConnectionState.done
                ? FutureBuilder<List<EventsDTO>>(
                    future: EventsVM.getAllListEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          return _search.length != 0 ||
                                  _controller.text.isNotEmpty
                              ? Center(
                                  child: _search.length != 0
                                      ? ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: _search.length,
                                          itemBuilder: (context, i) {
                                            return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 20),
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            blurRadius: 9,
                                                            color: Colors
                                                                .grey[300],
                                                            offset:
                                                                Offset(0, 3))
                                                      ]),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                        width: double.infinity,
                                                        height: 160,
                                                        child: Stack(
                                                          children: <Widget>[
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child:
                                                                  Image.network(
                                                                '${_search[i].thumbnailPicture}',
                                                                width: double
                                                                    .infinity,
                                                                height: 160.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            InkWell(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              onTap: () {
                                                                var screenHome =
                                                                    "HomePage";
                                                                setState(() {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                          MaterialPageRoute(
                                                                    builder: (context) => RegisterEventPage(
                                                                        uid:
                                                                            uid,
                                                                        idEvents:
                                                                            _search[i]
                                                                                .id,
                                                                        tracking:
                                                                            _search[i]
                                                                                .gpsTrackingRequired,
                                                                        screenHome:
                                                                            screenHome),
                                                                  ));
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        )),
                                                    ListTile(
                                                      title: Text(
                                                        _search[i].title,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18.0),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      subtitle: Text(
                                                        dtf.format(DateTime
                                                            .parse(_search[i]
                                                                .startedAt)),
                                                        style: TextStyle(
                                                            fontSize: 16.0),
                                                      ),
                                                      trailing: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 35.0),
                                                        child: FlatButton(
                                                          onPressed: () {
                                                            var screenHome =
                                                                "HomePage";
                                                            setState(() {
                                                              Navigator.of(context).push(MaterialPageRoute(
                                                                  builder: (context) => RegisterEventPage(
                                                                      uid: uid,
                                                                      idEvents:
                                                                          _search[i]
                                                                              .id,
                                                                      tracking:
                                                                          _search[i]
                                                                              .gpsTrackingRequired,
                                                                      screenHome:
                                                                          screenHome)));
                                                            });
                                                          },
                                                          child: Text(
                                                            'Join now',
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ));
                                          })
                                      : Center(
                                          child: Text(
                                            '${_tmpSMS}',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.orange[600]),
                                          ),
                                        ),
                                )
                              : listEvents();
                        }
                        ;
                      } else if (snapshot.data == null) {
                        _tmpSMS;
                      }
                      return Center(
                        child: Text(
                          '${_tmpSMS}',
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.orange[600]),
                        ),
                      );
                    })
                : Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text('Loading...'),
                      ],
                    ),
                  )));
  }
}
