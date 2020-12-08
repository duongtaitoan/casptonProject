import 'dart:convert';
import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/Model/feedbackDAO.dart';
import 'package:designui/src/Model/feedbackDTO.dart';
import 'package:designui/src/View/history.dart';
import 'package:designui/src/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedBackPage extends StatefulWidget {
  final FirebaseUser uid;
  final nameEvents;
  final idEvent;
  final screenHome;
  const FeedBackPage({Key key, this.uid,this.nameEvents,this.screenHome,this.idEvent}) : super(key: key);

  @override
  _FeedBackPageState createState() => _FeedBackPageState(uid,nameEvents,this.screenHome,this.idEvent);
}

class _FeedBackPageState extends State<FeedBackPage> {
  final FirebaseUser uid;
  var nameEvents;
  final idEvent;
  final screenHome;
  _FeedBackPageState(this.uid,this.nameEvents,this.screenHome,this.idEvent);
  String question1;
  String question2;
  String question3;
  String question4;
  String question5;
  String question6;
  String question7;
  String question8;
  var answer1 = "Kém";
  var answer2 = "Kém";
  var answer3 = "Kém";
  var answer4 = "Kém";
  var answer5 = "Kém";
  static var answer6 ;
  static var answer7 ;
  static var answer8 ;

  @override
  void initState() {
    question1 = "Sự kiện đạt mục tiêu so với mong đợi ?";
    question2 = "Tính hữu ích của sự kiện ?";
    question3 = "Nội dung của sự kiện ?";
    question4 = "Các tài liệu tham khảo ?";
    question5 = "Khâu tổ chức sự kiện (thiết bị, phòng ốc..) ?";
    question6 = "A. Những điều khiến bạn thích nhất ở sự kiện (ứng dụng cho công việc của bạn, giúp bạn cải thiện kỹ năng…) ?\n";
    question7 = "B. Những điều bạn KHÔNG thích nhất ở sự kiện ?\n";
    question8 = "C. Đề xuất bất kỳ của bạn cho sự kiện ?\n";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
          child: Scaffold(
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
                  builder: (context) => HistoryPage(uid: uid,)), (
                  Route<dynamic> route) => false);
                  }
                }
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 10, right: 16, left: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    returnAnsQue(1, question1,dropdownRating(answer1,1)),
                    returnAnsQue(2, question2,dropdownRating(answer2,2)),
                    returnAnsQue(3, question3,dropdownRating(answer3,3)),
                    returnAnsQue(4, question4,dropdownRating(answer4,4)),
                    returnAnsQue(5, question5,dropdownRating(answer5,5)),
                    SizedBox(height: 20,),
                    returnQuestion(question6,1),
                    returnQuestion(question7,2),
                    returnQuestion(question8,3),
                    Container(
                      margin: EdgeInsets.only(top: 40, right: 8, left: 8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: RaisedButton(
                          onPressed: () async {
                            if(answer6 == null || answer7 == null || answer8 == null){
                              await ShowMessage.functionShowDialog("Please comment your content ",context);
                            }else {
                              //conver Question and answer to json
                              List<FeedbackDTO> dto =[new FeedbackDTO(question: question1, answer:answer1),
                                new FeedbackDTO(question: question2, answer:answer2),
                                new FeedbackDTO(question: question3, answer:answer3),
                                new FeedbackDTO(question: question4, answer:answer4),
                                new FeedbackDTO(question: question5, answer:answer5),
                                new FeedbackDTO(question: question6, answer:answer6),
                                new FeedbackDTO(question: question7, answer:answer7),
                                new FeedbackDTO(question: question8, answer:answer8)];

                                var toJson = jsonEncode(dto);
                                var handerFeedback = await FeedBackDAO().postFeedback(toJson, idEvent);;
                                try {
                                  if (handerFeedback["message"] == "Success") {
                                    await ShowMessage.functionShowDialog(
                                        "Your content has been submitted successfully",
                                        context);
                                    Future.delayed(
                                        new Duration(seconds: 2), () {
                                      Navigator.pushAndRemoveUntil(context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage(uid: uid,)), (
                                              Route<dynamic> route) => false);
                                    });
                                  }
                                }catch(e) {
                                  await ShowMessage.functionShowDialog(
                                  "You already give a feedback",context);
                              }
                            }
                          },
                          child: Text('Send', style: TextStyle(fontSize: 20.0,
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
    return ListTile(
      title: Text('${ask}',
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
          onChanged: (value){
            setState(() {
              if(select == 1){
                answer6 = value;
              }else if(select == 2){
                answer7 = value;
              }else if( select == 3){
                answer8 = value;
              }
            });
          },
        ),
      ),
    );
  }

  dropdownRating(dropdownValue,select) {
    return DropdownButtonFormField<String>(
      disabledHint: Text('${dropdownValue}'),
      isExpanded: true,
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward,color: Colors.blue[500],),
      iconSize: 24,
      onChanged: (newValue)async{
        setState(() {
          if(select == 1){
            answer1 = newValue;
          }else if(select == 2){
            answer2 = newValue;
          }else if(select == 3){
            answer3 = newValue;
          }else if( select == 4){
            answer4 = newValue;
          }else if(select == 5){
            answer5 = newValue;
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
