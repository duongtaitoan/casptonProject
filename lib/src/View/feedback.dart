import 'package:designui/src/Helper/list_Ques_Ans.dart';
import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/View/history.dart';
import 'package:designui/src/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeedBackPage extends StatefulWidget {
  final FirebaseUser uid;
  final nameEvents;
  final screenHome;
  const FeedBackPage({Key key, this.uid,this.nameEvents,this.screenHome}) : super(key: key);

  @override
  _FeedBackPageState createState() => _FeedBackPageState(uid,nameEvents,this.screenHome);
}

class _FeedBackPageState extends State<FeedBackPage> {
  final FirebaseUser uid;
  var nameEvents;
  final screenHome;
  _FeedBackPageState(this.uid,this.nameEvents,this.screenHome);
  var _tmpInput;
  String ques1;
  String ques2;
  String ques3;
  String ques4;
  String ques5;
  String ask1;
  String ask2;
  String ask3;

  @override
  void initState() {
    ques1 = "Sự kiện đạt mục tiêu so với mong đợi ?";
    ques2 = "Tính hữu ích của sự kiện ?";
    ques3 = "Nội dung của sự kiện ?";
    ques4 = "Các tài liệu tham khảo ?";
    ques5 = "Khâu tổ chức sự kiện (thiết bị, phòng ốc..) ?";
    ask1 = "A. Những điều khiến bạn thích nhất ở sự kiện (ứng dụng cho công việc của bạn, giúp bạn cải thiện kỹ năng…) ?\n";
    ask2 = "B. Những điều bạn KHÔNG thích nhất ở sự kiện ?\n";
    ask3 = "C. Đề xuất bất kỳ của bạn cho sự kiện ?\n";

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
              // automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                if(screenHome == "HomePage"){
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
                    returnAnsQue(1, ques1),
                    returnAnsQue(2, ques2),
                    returnAnsQue(3, ques3),
                    returnAnsQue(4, ques4),
                    returnAnsQue(5, ques5),
                    SizedBox(height: 20,),
                    returnQuestion(ask1),
                    returnQuestion(ask2 ),
                    returnQuestion(ask3),
                    Container(
                      margin: EdgeInsets.only(top: 40, right: 8, left: 8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: RaisedButton(
                          onPressed: () async {
                            await ShowMessage.functionShowMessage("Your content has been submitted successfully");
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) =>
                                    HomePage(uid: uid,)), (
                                    Route<dynamic> route) => false);
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
  Widget returnAnsQue(count, question) {
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
          child: QADropDown(),
        ),
        SizedBox(height: 5,),
      ],
    );
  }

  Widget returnQuestion(String ask){
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
          onChanged: (_tmpInput){
            print('input ${_tmpInput}');
            setState(() {
            });
            return _tmpInput;
          },
        ),
      ),
    );
  }
}
