import 'dart:convert';
import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/Model/answerDTO.dart';
import 'package:designui/src/Model/feedbackDAO.dart';
import 'package:designui/src/Model/feedbackDTO.dart';
import 'package:designui/src/View/history.dart';
import 'package:designui/src/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedBackPage extends StatefulWidget {
  final FirebaseUser uid;
  final nameEvents;
  final idEvent;
  final screenHome;
  final idStudent;
  const FeedBackPage({Key key, this.uid,this.nameEvents,this.screenHome,this.idEvent,this.idStudent}) : super(key: key);

  @override
  _FeedBackPageState createState() => _FeedBackPageState(uid,nameEvents,this.screenHome,this.idEvent,this.idStudent);
}

class _FeedBackPageState extends State<FeedBackPage> {
  final FirebaseUser uid;
  var nameEvents;
  final idEvent;
  final idStudent;
  final screenHome;
  _FeedBackPageState(this.uid,this.nameEvents,this.screenHome,this.idEvent,this.idStudent);
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var dropdownValue;
  var idQuestion;
  List<AnswerDTO> answerValue = new List<AnswerDTO>();
  List<InfoAnswer> listAnswer = new List<InfoAnswer>();
  List<String> getLastString = new List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Feedback events ${nameEvents}'),
              backgroundColor: Colors.orange[600],
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () async {
                if(screenHome == "HomePage"){
                  ShowMessage.functionShowDialog("Maybe feedback later", context);
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) =>
                          HomePage(uid: uid,)), (
                          Route<dynamic> route) => false);
                }else{
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => HomePage(uid: uid,)), (
                  Route<dynamic> route) => false);
                  }
                }
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 10, right: 16, left: 16),
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 0,
                      child: FutureBuilder<List<FeedbackDTO>>(
                        future: FeedBackDAO().getListQuestion(),
                        builder: (BuildContext context, AsyncSnapshot<List<FeedbackDTO>> snapshot) {
                        if (snapshot.hasData)
                          return ListView.builder(
                            // crossAxisCount: 1,
                            // scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                child: snapshot.data[index].type =="RATING"
                                    ? returnAnsQue(snapshot.data[index].id, snapshot.data[index].question,dropdownRating(snapshot.data[index].id))
                                    : returnQuestion(snapshot.data[index].question,snapshot.data[index].id),
                              );
                            }
                          );
                        return Container(child: CircularProgressIndicator());
                        },
                      ),
                    ),

                   Container(
                        margin: EdgeInsets.only(top: 40, right: 8, left: 8,bottom: 30),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: RaisedButton(
                            onPressed: () async {
                              var valueComment = await returnLastComment(idQuestion);
                              // check list answer not null
                              if(answerValue == null && valueComment == null){
                                await ShowMessage.functionShowDialog("Please comment your content ",context);
                              }else {
                                SharedPreferences sp = await SharedPreferences.getInstance();
                                String token = sp.getString("token_data");
                                var decodedToken= JwtDecoder.decode(token);
                                var idStudents = int.parse(decodedToken["sub"]);
                                DateTime now = new DateTime.now();
                                // save list answer
                                List<dynamic> chckList = answerValue.map((e) => (e.toJson())).toList();
                                var sms = await FeedBackDAO().postFeedback(idEvent,idStudents,now.toUtc().toIso8601String(),chckList);
                                // notification message by popup
                                  try {
                                    if(sms != ""){
                                        await ShowMessage.functionShowDialog("${sms}", context);
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(builder: (context) => HomePage(uid: uid,)), (
                                                  Route<dynamic> route) => false);
                                    }else {
                                        await ShowMessage.functionShowDialog("Your content has been submitted successfully", context);
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(builder: (context) => HomePage(uid: uid,)), (
                                                  Route<dynamic> route) => false);
                                    }
                                  }catch(e) {
                                    await ShowMessage.functionShowDialog("You already give a feedback",context);
                                      Navigator.pushAndRemoveUntil(context,
                                          MaterialPageRoute(builder: (context) => HomePage(uid: uid,)), (
                                              Route<dynamic> route) => false);
                                }
                              }
                            },
                            child: Text('Submit', style: TextStyle(fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),),
                            color: Colors.orange[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  // Question
  Widget returnAnsQue(count, question,rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
             child: ListTile(
                title: Text('Câu ${count} : ${question}', style: TextStyle(
                    color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
              ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 5.0),
          child: rating,
        ),
        SizedBox(height: 5,),
      ],
    );
  }

  Widget returnQuestion(String ask,select){
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: ListTile(
        title: Text('Câu ${select} : ${ask}',
          style: TextStyle(fontSize: 18.0),),
        subtitle: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1,),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.only(left: 10),
                hintText: '',
                hintStyle: TextStyle(
                    color: Colors.black, fontSize: 20.0)),
            style: TextStyle(color: Colors.black),
            onChanged: (value) async {
              for (int i = 0 ;i <= select ;i ++){
                if(i == select){
                  idQuestion = select;
                  return await getLastString.add(value);
                }
              }
           }
          ),
        ),
      ),
    );
  }

  // return last comment
  returnLastComment(idQuestion){
    try {
      return answerValue.add(new AnswerDTO(
          questionId: idQuestion, answer: getLastString.last, rating: 0));
    }catch(e){
    }
  }

  // rating value
  dropdownRating(select) {
    return DropdownButtonFormField<String>(
      disabledHint: Text('${dropdownValue}'),
      isExpanded: true,
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward,color: Colors.blue[500],),
      iconSize: 24,
      onChanged: (newValue)async{
        setState(() {
          for (int i = 1 ;i <= select ;i ++){
            if(i == select){
              var rating = 1;
              setState(() {
                if(newValue =="Kém"){
                  rating = 1;
                }else if(newValue =="Trung bình"){
                  rating = 2;
                }else if(newValue =="Khá"){
                  rating = 3;
                }else if(newValue =="Tốt"){
                  rating = 4;
                }else if(newValue =="Xuất sắc"){
                  rating = 5;
                }
                return answerValue.add(new AnswerDTO(questionId:i,rating: rating));
              });
            }
          }
        }
        );
      },
      items: <String>['Kém','Trung bình','Khá','Tốt','Xuất sắc']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
