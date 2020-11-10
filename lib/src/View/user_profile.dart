import 'package:designui/src/Helper/list_Semester.dart';
import 'package:designui/src/Model/user_profileDAO.dart';
import 'package:designui/src/Model/user_profileDTO.dart';
import 'package:designui/src/View/menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProfilePage extends StatefulWidget {
  final FirebaseUser uid;

  const UserProfilePage({Key key, this.uid}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState(uid);
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseUser uid;
  UserProfileDAO dao;
  _UserProfilePageState(this.uid);
  bool _validate = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controlNumber = TextEditingController();
  final TextEditingController controlMSSV = TextEditingController();
  TextEditingController controlMajor = TextEditingController();

  @override
  void initState() {
    dao = new UserProfileDAO();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var email = uid.email;
    var displayName = uid.displayName;
    return SafeArea(
        child:SizedBox.expand(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Personal information'),
              backgroundColor: Colors.orange[600],
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>
                    Navigator.of(context).pop(),
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
                          Container(
                            child: Expanded(
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
                                      Text("Fullname", style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold)),
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
                                           Text("Phone",style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold)),
                                         ],
                                       ),
                                       Padding(
                                         padding: const EdgeInsets.only(left: 15,right: 15),
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: <Widget>[
                                             TextField(
                                               keyboardType: TextInputType.number,
                                               controller: controlNumber,
                                               decoration: InputDecoration(
                                                 hintText: '0836831237',
                                                 suffixIcon: Icon(Icons.star,color: Colors.red,size: 10,),
                                                 errorText: _validate == true ? 'Phone number can\'t be empty' : null
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
                                        Text("Student code", style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15,right: 15),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          TextField(
                                            controller: controlMSSV,
                                            decoration: InputDecoration(
                                              hintText: 'SE63438',
                                              suffixIcon: Icon(Icons.star,color: Colors.red,size: 10,),
                                              errorText: _validate== true ? 'Student code is can\'t be empty' : null,
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
                                         Text("Major", style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold)),
                                       ],
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(left: 15,right: 15),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                                         children: <Widget>[
                                           // SemesterDropDown(),
                                           TextFormField(
                                             controller: controlMajor,
                                             decoration: InputDecoration(
                                               hintText: 'information system',
                                               suffixIcon: Icon(Icons.star,color: Colors.red,size: 10,),
                                               errorText: _validate== true ? 'Major is can\'t be empty' : null,
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                              ],
                            ),),
                          ),
                          Expanded(
                            flex: 0,
                            child:  Container(
                              margin: EdgeInsets.only(top: 120,right: 16,left: 11),
                              child: SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: RaisedButton(
                                  onPressed: () async {
                                    if(validateMobile(controlNumber.text) == null &&
                                        validateCode(controlMSSV.text.toLowerCase()) == null &&validateMajor(controlMajor.text) == null ) {
                                          String _tmpNum = controlNumber.text;
                                          String _tmpMajor = controlMajor.text;
                                          String _tmpMSSV = controlMSSV.text;

                                          var status = dao.getInforProfile(
                                              new UserProfileDTO(studentCode: _tmpMSSV,major: _tmpMajor,phone: int.parse(_tmpNum)));
                                          status.then((value) =>
                                            Fluttertoast.showToast(
                                            msg: value,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIos: 3,
                                            fontSize: 20.0,
                                            textColor: Colors.black));
                                    }else if(validateMobile(controlNumber.text) != null){
                                      setState(() {
                                        controlNumber.text.isEmpty ? _validate = true : _validate = false;
                                      });
                                      showToast(validateMobile(controlNumber.text));
                                    }else if(validateCode(controlMSSV.text) != null){
                                      setState(() {
                                        controlMSSV.text.isEmpty ? _validate = true : _validate = false;
                                      });
                                      showToast(validateCode(controlMSSV.text));
                                    }else if(validateMajor(controlMajor.text) != null){
                                      setState(() {
                                        controlMajor.text.isEmpty ? _validate = true : _validate = false;
                                      });
                                      showToast(validateMajor(controlMajor.text));
                                    }
                                  },
                                  child: Text('Update information', style: TextStyle(fontSize: 18.0, color: Colors.white),),
                                  color: Colors.orange[600],
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

  // check mobile phone
  validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please phone number is blank';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Your phone number invalid \n Ex: 0838625825';
    }
    return null;
  }

  // check id student code
  validateCode(String value) {
    String pattern = r'(^(([SE]|[SS]|[SA]){2})([0-9]{3,8})$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please students code is blank';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Your students code invalid \n Ex: SE62334';
    }
    return null;
  }

  // check major
  validateMajor(String value) {
    String pattern = r'(^[a-zA-Z]?.{10,50}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Major is blank';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Pleas insert your major';
    }
    return null;
  }

  // show status toast
  Widget showToast(String tmpStatus){
     Fluttertoast.showToast(
        msg: tmpStatus,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        fontSize: 20.0,
        textColor: Colors.black);
  }
}
