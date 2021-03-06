import 'package:designui/src/Helper/show_message.dart';
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
  static DateFormat dtf = DateFormat('HH:mm a dd/MM/yyyy');
  var checkSearch = false;

  @override
  void initState() {
    _search = List<EventsDTO>();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _controller = TextEditingController();
    vmDao = new EventsVM();
    super.initState();
    try {
      model = new ViewAllVM();
      model.pageFrist(context);
    }catch(e){
    }
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
                    onFieldSubmitted: (textInput){
                      if (textInput.length <= 0) {
                        _controller.clear();
                        searchEvents('');
                      }else if(textInput.length > 0){
                        setState(() {
                          searchEvents(textInput);
                        });
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
                  context, MaterialPageRoute(
                      builder: (context) => HomePage(uid: uid,)),
                  (Route<dynamic> route) => false),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                getEvent(context, uid, _search, _controller),
              ],
            ),
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
        if (ShowMessage.utf8convert(ex.title).toUpperCase().contains(delayInput.toUpperCase())) {
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
                  padding: const EdgeInsets.all(20.0),
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
                                child: element.thumbnailPicture == null
                                    ? Center(child: new Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          new CircularProgressIndicator(),
                                          new Text("Loading"),
                                        ],),)
                                    : Image.network(
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
                                                        .gpsTrackingRequired,nameLocation: element.location,)));
                                  });
                                },
                              ),
                            ],
                          )),
                      ListTile(
                        title: Text(element.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                          textAlign: TextAlign.start,
                        ),
                        subtitle: Text(
                          dtf.format(DateTime.parse(element.startTime)),
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
                                            element.gpsTrackingRequired,nameLocation: element.location)));
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
                        ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center (child: CircularProgressIndicator(),),
                        )
                        : FlatButton(
                            child: Center(
                              child: model.mgs == null
                                  ? Text("Load more",style: TextStyle(fontSize: 18.0,color: Colors.orange[600]))
                                  : Text("${model.mgs}",style: TextStyle(fontSize: 18.0,color: Colors.orange[600]),),
                            ),
                            onPressed: () async {
                              await model.pageIndex();
                            },
                          )
                  ],
                );
              }else if(model.listEvent.length == 0 || model.listEvent == null){
                return Padding (
                  padding: const EdgeInsets.only(top:250),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(child:Text('${model.mgs}',style: TextStyle(fontSize: 18.0,color: Colors.orange[600]),))
                    ],
                  ),
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
    var _tmpSMS = "";
    return SingleChildScrollView(
        child: FutureBuilder(
            future: Future.delayed(Duration(seconds: 1)),
            builder: (c, s) => s.connectionState == ConnectionState.done
                ? FutureBuilder<List<EventsDTO>>(
                    future: EventsVM.getAllListEvents(),
                    builder: (context, snapshot) {
                      try {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            if (snapshot.data.length == 0) {
                              _tmpSMS = "Not found events";
                            } else {
                              return _search.length != 0 || _controller.text.isNotEmpty
                                  ? Center(child: _search.length != 0
                                  ? ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _search.length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0,bottom: 15,top: 5),
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 0),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),),
                                              boxShadow: [
                                                BoxShadow(blurRadius: 9,
                                                    color: Colors.grey[300],
                                                    offset: Offset(0, 3))
                                              ]),
                                          padding: const EdgeInsets.only(
                                              top: 0),
                                          child: Column(children: <Widget>[
                                            Container(
                                                width: double.infinity,
                                                height: 160,
                                                child: Stack(
                                                  children: <Widget>[
                                                    ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                      child: _search[i].thumbnailPicture == null
                                                          ? Center(child: new Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              new CircularProgressIndicator(),
                                                              new Text("Loading"),
                                                            ],),)
                                                          : Image.network(
                                                            '${_search[i]
                                                                .thumbnailPicture}',
                                                            width: double.infinity,
                                                            height: 160.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                    ),
                                                    InkWell(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                      onTap: () {
                                                        var screenHome = "HomePage";
                                                        setState(() {
                                                          Navigator.of(context)
                                                              .push(
                                                              MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    RegisterEventPage(
                                                                        uid: uid,
                                                                        idEvents: _search[i]
                                                                            .id,
                                                                        tracking: _search[i]
                                                                            .gpsTrackingRequired,
                                                                        screenHome: screenHome,nameLocation:_search[i].location),));
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                )
                                            ),
                                            ListTile(
                                              title: Text(ShowMessage.utf8convert(_search[i].title),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                                textAlign: TextAlign.start,),
                                              subtitle: Text(dtf.format(
                                                  DateTime.parse(
                                                      _search[i].startTime)),
                                                style: TextStyle(
                                                    fontSize: 16.0),),
                                              trailing: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 35.0),
                                                child: FlatButton(
                                                  onPressed: () {
                                                    var screenHome = "HomePage";
                                                    setState(() {
                                                      Navigator.of(context)
                                                          .push(
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  RegisterEventPage(
                                                                      uid: uid,
                                                                      idEvents: _search[i]
                                                                          .id,
                                                                      tracking: _search[i]
                                                                          .gpsTrackingRequired,
                                                                      screenHome: screenHome,nameLocation: _search[i].location)));
                                                    });
                                                  },
                                                  child: Text('Join now',
                                                    style: TextStyle(
                                                      fontSize: 16.0,),
                                                    textAlign: TextAlign.end,),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ));
                                  })
                                  : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 250),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Center(child: Text(
                                            '${"Not found events"}',
                                            style: TextStyle(fontSize: 18.0,
                                                color: Colors.orange[600]),))
                                        ],
                                      ),
                                    )
                                  ,)
                                ,)
                                  : listEvents();
                            }
                          }
                        }
                        else if (snapshot.error || snapshot.hasError) {
                          _tmpSMS = "Not found events";
                        }
                      }catch(e){}
                      return Padding (
                        padding: const EdgeInsets.only(top:250),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Center(child:Text('${_tmpSMS}',style: TextStyle(fontSize: 18.0,color: Colors.orange[600]),))
                          ],
                        ),
                      );
                    })
                : Padding(
                    padding: const EdgeInsets.only(top: 200),
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
                  )
        )
    );
  }
}
