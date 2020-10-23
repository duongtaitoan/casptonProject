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

    return SafeArea(
        child:SizedBox.expand(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Thông tin cá nhân'),
              backgroundColor: Colors.orange[400],
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => HomePage(
                          uid: uid,)),
                        (Route<dynamic> route) => false),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10,),
                Flexible(
                  flex: 6,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            margin: const EdgeInsets.all(0),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.email, size: 20.0,),
                                SizedBox(width: 15,),
                                Text("Gmail ", style: TextStyle(color: Colors.black, fontSize: 18.0)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            margin: const EdgeInsets.all(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  '$email',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              margin: const EdgeInsets.all(0.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.person_outline,
                                    size: 20.0,
                                  ),
                                  Text("Họ và tên ", textAlign:TextAlign.center,
                                      style: TextStyle(color: Colors.black, fontSize: 18.0)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              margin: const EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    '$displayName',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              margin: const EdgeInsets.all(0.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.card_giftcard,
                                    size: 20.0,
                                  ),
                                  Text("Năm Sinh ",textAlign:TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18.0)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(left: 25),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  DateTimeField(
                                    textAlign: TextAlign.center,
                                    format: format,
                                    decoration: InputDecoration(
                                      hintText: '10/10/2000',
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate:
                                          currentValue ?? DateTime.now(),
                                          lastDate: new DateTime.now());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex:5,
                            child: Container(
                              width: double.infinity,
                              height: 70,
                              margin: const EdgeInsets.only(left: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InternationalPhoneNumberInput(
                                    maxLength: 10,
                                    onInputChanged: (PhoneNumber number) {
                                      print(number.phoneNumber);
                                    },
                                    // show for user by list or dialog or ....
                                    selectorConfig: SelectorConfig(
                                      selectorType: PhoneInputSelectorType.DIALOG,
                                    ),
                                    selectorTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                    ),
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
                      SizedBox(height: 5,),
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
                                    size: 20.0,
                                  ),
                                  Text("Chuyên ngành ", textAlign:TextAlign.center,
                                      style: TextStyle(color: Colors.black, fontSize: 15.0)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              margin: const EdgeInsets.only(left: 0),
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                    controller: controlMajors,
                                    textAlign: TextAlign.center,
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
                ),
                SizedBox(height: 30,),
                Flexible(
                  flex: 0,
                  fit: FlexFit.tight,
                  child: Container(
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
                              textColor: Colors.black);
                        },
                        child: Text(
                          'Cập nhật thông tin',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        color: Colors.orange[400],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        )
    );
  }
}
