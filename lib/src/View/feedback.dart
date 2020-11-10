import 'package:designui/src/Helper/list_Ques_Ans.dart';
import 'package:designui/src/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeedBackPage extends StatefulWidget {
  final FirebaseUser uid;
  final nameEvents;
  const FeedBackPage({Key key, this.uid,this.nameEvents}) : super(key: key);

  @override
  _FeedBackPageState createState() => _FeedBackPageState(uid,nameEvents);
}

class _FeedBackPageState extends State<FeedBackPage> {
  final FirebaseUser uid;
  var nameEvents;
  _FeedBackPageState(this.uid,this.nameEvents);

  String ques1;
  String ques2;
  String ques3;
  String ques4;

  @override
  void initState() {
    ques1 = "Bạn có hài lòng với sự kiện này không ?";
    ques2 = "Bạn cảm thấy nội dung chương trình thế nào ?";
    ques3 = "Bạn cảm thấy sự kiện này có ích không ?";
    ques4 = "Bạn có thấy sự kiện này có mang lại lợi ích gì không ?";

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
                onPressed: () =>
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) => HomePage(uid: uid,)), (
                        Route<dynamic> route) => false),
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
                    SizedBox(height: 20,),
                    Container(
                      width: double.infinity,
                      height: 316.0,
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                              maxLines: null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                  EdgeInsets.only(left: 25.0, top: 15.0),
                                  hintText: 'More feedback',
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                              style: TextStyle(color: Colors.black),
                              onFieldSubmitted: (String input) {}),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40, right: 8, left: 8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: RaisedButton(
                          onPressed: () async {
                            await Fluttertoast.showToast(
                                msg: "Your content has been submitted successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIos: 3,
                                fontSize: 20.0,
                                textColor: Colors.black
                              // back to home
                            );
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
          padding: const EdgeInsets.only(top: 15),
          child: Text('Câu ${count}', style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
        ),
        Center(
          child: Text('${question}',
            style: TextStyle(color: Colors.black, fontSize: 18.0,),),
        ),
        Center(
          child: QADropDown(),
        ),
        SizedBox(height: 5,),
      ],
    );
  }
}
