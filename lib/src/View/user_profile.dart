import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/Model/user_profileDAO.dart';
import 'package:designui/src/Model/user_profileDTO.dart';
import 'package:designui/src/View/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  final FirebaseUser uid;
  final status;
  const UserProfilePage({Key key, this.uid,this.status}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState(uid,status);
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseUser uid;
  final status;
  UserProfileDAO dao;
  _UserProfilePageState(this.uid,this.status);
  bool _validate = false;
  Map<String, dynamic> decodedToken;
  var _tmpInfor;
  String dropdownValue;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controlNumber = TextEditingController();
  final TextEditingController controlMSSV = TextEditingController();
  TextEditingController controlMajor = TextEditingController();

  @override
  void initState(){
    dropdownValue="Information System";
    dao = new UserProfileDAO();
    super.initState();
    try {
      getstudentCode().then((value) {
        try {
          controlMSSV.text = value["studentCode"];
          controlMajor.text = value["major"];
          if (value["phoneNumber"] == null) {
            ShowMessage.functionShowMessage(
                "Please check your information again!");
          } else {
            controlNumber.text = value["phoneNumber"];
          }
        }catch(e){
          if(status != null){
            ShowMessage.functionShowMessage("${status}");
          }
        }
      setState(() {});
      });
    }catch(e){
    }
  }

  @override
  Widget build(BuildContext context) {
    var email = uid.email;
    var displayName = uid.displayName;
    return SafeArea(
        child:SizedBox.expand(
          child: Scaffold(
            appBar: status.toString().compareTo("You need to update information")!=0
              ? AppBar(
                  title: Text('Personal information',textAlign: TextAlign.center,),
                  backgroundColor: Colors.orange[600],
                  elevation: 0,
                  automaticallyImplyLeading: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () =>
                        Navigator.of(context).pop(),
                  ),)
              : AppBar(
                  title: Text('Personal information',textAlign: TextAlign.center),
                  backgroundColor: Colors.orange[600],
                  elevation: 0,
                  automaticallyImplyLeading: false,
            ),
            body: FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 500),),
                builder: (c, s) => s.connectionState == ConnectionState.done
                    ? Column(
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
                                          handlerUserInfor("Gmail",email),
                                          SizedBox(height: 30,),
                                          handlerUserInfor("Fullname", displayName),
                                          SizedBox(height: 30,),
                                          handlerUserUpdate("Phone",controlNumber,TextInputType.number,'Ex: 0836831237','Phone number can\'t be empty'),
                                          SizedBox(height: 30,),
                                          handlerUserUpdate("Student code", controlMSSV, TextInputType.text, "Ex: SE63438", 'Student code is can\'t be empty'),
                                          SizedBox(height: 30,),
                                          Row(
                                            children: <Widget>[
                                              SizedBox(width: 15,),
                                              Text("Major",style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only( left: 16.0,right: 16.0),
                                            child: dropdownMajor(),
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
                                            if(validateMobile(controlNumber.text) != null){
                                              setState(() {
                                                controlNumber.text.isEmpty ? _validate = true : _validate = false;
                                              });
                                              ShowMessage.functionShowMessage(validateMobile(controlNumber.text));

                                            }else if(validateCode(controlMSSV.text) != null){
                                              setState(() {
                                                controlMSSV.text.isEmpty ? _validate = true : _validate = false;
                                              });
                                              ShowMessage.functionShowMessage(validateCode(controlMSSV.text));

                                            } else{
                                              // update userprofile
                                              String _tmpNum = controlNumber.text;
                                              String _tmpMajor = dropdownValue;
                                              String _tmpMSSV = controlMSSV.text.toUpperCase();

                                              var _tmpUpdate = await dao.updateInforUser(new UserProfileDTO(
                                                  studentCode: _tmpMSSV,phone: _tmpNum,major: _tmpMajor)
                                                  ,int.parse(decodedToken["userId"]));
                                              await ShowMessage.functionShowMessage(_tmpUpdate);

                                              if(status!= null && _tmpUpdate.compareTo("Update successful")==0){
                                                Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => HomePage(uid: uid)));
                                              }else{
                                                 ShowMessage.functionShowMessage(_tmpUpdate);
                                              }
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
                      )
                    : Center(
                      child: Column(children: <Widget>[
                          CircularProgressIndicator(),
                          Text('Loading....')
                        ],
                      )
                  )
            ),
          )
        )
    );
  }

  // check mobile phone
  validateMobile(String value) {
    String pattern = r'((84|0[1-9]{1})+([0-9]{8})$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Phone number is blank';
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
      return 'Students code is blank';
    }
    else if (!regExp.hasMatch(value.toUpperCase())) {
      return 'Your students code invalid [SE]|[SS]|[SA] \n Ex: SE62334';
    }
    return null;
  }

  Future<dynamic> getstudentCode() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token_data");
      decodedToken = JwtDecoder.decode(token);
      _tmpInfor = await UserProfileDAO().getInforUser(int.parse(decodedToken["userId"]));
      return _tmpInfor;
    }catch(e){
      // return "System is update waiting for minus";
    }
  }

  // infor of user not change
  Widget handlerUserInfor(String title, nameTitle){
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          SizedBox(width: 15,),
          Text("${title}", style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold),),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 15,),
          Text('$nameTitle', textAlign: TextAlign.start, style: TextStyle(fontSize: 18.0),),
        ],
      ),
    ],
    );
  }

  // text field user can update
  Widget handlerUserUpdate(String tmpPhone, tmpController,type,String hint,String invalid){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 15,),
            Text("${tmpPhone}",style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15,right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                keyboardType: type,
                controller: tmpController,
                decoration: InputDecoration(
                    // errorText: hint,
                    hintText: hint,
                    suffixIcon: Icon(Icons.star,color: Colors.red,size: 10,),
                    errorText: _validate== true && getstudentCode() == null ? invalid : null
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // button dropdown semester
  dropdownMajor() {
    return DropdownButtonFormField<String>(
      disabledHint: Text('${dropdownValue}'),
      isExpanded: true,
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward,color: Colors.blue[500],),
      iconSize: 24,
      onChanged: (newValue)async{
        setState(() {
          dropdownValue = newValue;
        }
        );
      },
      items: <String>['Information System','Business Administration','English Language']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

}
