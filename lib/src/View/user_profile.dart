import 'package:designui/src/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProfilePage extends StatefulWidget {
  final FirebaseUser uid;
  const UserProfilePage({Key key, this.uid}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState(uid);
}

class _UserProfilePageState extends State<UserProfilePage> {
   final FirebaseUser uid;
   _UserProfilePageState(this.uid);

   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
   final TextEditingController controlMajors = TextEditingController();
   final TextEditingController controlNumber = TextEditingController();
   PhoneNumber number = PhoneNumber(isoCode: 'VN');


  @override
  Widget build(BuildContext context) {

    var email = uid.email;
    var displayName = uid.displayName;
    final format = DateFormat("dd/MM/yyyy");

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
        backgroundColor: Colors.amberAccent[400],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> HomePage(uid: uid,)), (Route<dynamic> route) => false),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.all(0.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.email,
                                size: 25.0,
                              ),
                              Text("Gmail ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('$email',style: TextStyle(fontSize: 20.0),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.all(0.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.person_outline,
                                size: 25.0,
                              ),
                              Text("Họ và tên ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.all(0.0),
                          child: Row(
                            children: <Widget>[
                              Text('$displayName',style: TextStyle(fontSize: 20.0),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.all(0.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.card_giftcard,
                                size: 25.0,
                              ),
                              Text("Năm Sinh ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          width: 100,
                          height: 50,
                          margin: const EdgeInsets.all(0.0),
                          child: Column(
                            children: <Widget>[
                              DateTimeField(
                                format: format,
                                decoration: InputDecoration(
                                  hintText: '10/10/2000',
                                ),
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate: currentValue ?? DateTime.now(),
                                      lastDate: new DateTime.now());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.all(0.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox( width: 100,),
                              InternationalPhoneNumberInput(
                                maxLength: 10,
                                onInputChanged: (PhoneNumber number) {
                                  print(number.phoneNumber);
                                },
                                // show for user by list or dialog or ....
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                ),
                                selectorTextStyle: TextStyle(color: Colors.black,fontSize: 31.0,),
                                initialValue: number,
                                hintText: 'Vd: 0836 678 979',
                                locale: 'VN',
                                textFieldController: controlNumber,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.all(0.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.work,
                                size: 25.0,
                              ),
                              Text("Chuyên ngành ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.all(4.0),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: controlMajors,
                                decoration: InputDecoration(
                                  hintText: 'Vd: Công nghệ thông tin'
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 193),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RaisedButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                        msg: "Cập nhật thông tin thành công",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 3,
                        fontSize: 20.0,
                        textColor: Colors.black
                          );
                    },
                    child: Text(
                      'Cập nhật thông tin',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    color: Colors.amberAccent[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



