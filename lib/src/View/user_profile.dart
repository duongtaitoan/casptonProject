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
    DateTime birthdayStudent = DateTime.now();
    int relust = birthdayStudent.year - 18;
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
                Expanded(
                  flex: 10,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                          Expanded(
                            flex: 0,
                            child: Column(
                               children: <Widget>[
                               SizedBox(height: 30,),
                               Column(children: <Widget>[
                                  Row(
                                      children: <Widget>[
                                        SizedBox(width: 15,),
                                        Text("Gmail ", style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(width: 15,),
                                        Text('$email', textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                      ],
                                    ),
                              ],
                              ),
                               SizedBox(height: 30,),
                               Column(
                                children: <Widget>[
                                 Row(
                                  children: <Widget>[
                                    SizedBox(width: 15,),
                                    Text("Họ và tên ", style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold)),
                                  ],
                                 ),
                                 Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(width: 15,),
                                      Text('$displayName', textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                               SizedBox(height: 30,),
                               Column(
                                   children: <Widget>[
                                     Row(
                                       children: <Widget>[
                                         SizedBox(width: 15,),
                                         Text("Số điện thoại ",style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold)),
                                       ],
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(left: 15,right: 15),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         children: <Widget>[
                                           TextField(
                                             controller: controlMajors,
                                             decoration: InputDecoration(
                                               hintText: '0836831237',
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                               SizedBox(height: 30,),
                               Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      SizedBox(width: 15,),
                                      Text("Mã số sinh viên ", style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15,right: 15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        TextField(
                                          controller: controlMajors,
                                          // textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                            hintText: 'SE63438',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),),
                          Expanded(
                            flex: 0,
                            child:  Container(
                              margin: EdgeInsets.only(top: 230,right: 5),
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
                        ]),
                      ),
                    ),
                  ),
              ],
            ),
          )
        )
    );
  }
}
