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

  Map<String, dynamic> decodedToken;
  UserProfileDAO dao;
  String dropdownValue;
  String dropdownIntSemester;
  bool isCheck = false;

  var _tmpInfor;
  var matchesStudent;
  var saveSynMajor ="Another Major" ;

  _UserProfilePageState(this.uid,this.status);
  final TextEditingController controlNumber = TextEditingController();
  TextEditingController controlMajor = TextEditingController();
  TextEditingController controlSemester = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState(){
    dropdownIntSemester = "Any";
    dropdownValue="Another Major";
    dropdownSemester();

    RegExp pattern = new RegExp('([se|sa|sb|ss|SS|SE|SA|SB]{2})([0-9]{5,8})');
    var _tmpStudentCode = uid.email.split("@")[0];
    matchesStudent = pattern.stringMatch(_tmpStudentCode);

    dao = new UserProfileDAO();
    super.initState();
    try {
      getstudentCode().then((value) async {
        try {
          controlMajor.text = value["major"];
          if(controlMajor.text.toString().compareTo("Software Engineering")==0){
            dropdownValue="Software Engineering";
          }else if(controlMajor.text.toString().compareTo("Business Administration")==0){
            dropdownValue="Business Administration";
          }else if(controlMajor.text.toString().compareTo("English Language")==0){
            dropdownValue="English Language";
          }else if(controlMajor.text.toString().compareTo("Another Major")==0){
            dropdownValue="Another Major";
          }

          controlNumber.text = value["phoneNumber"];

          int _tmpIdSemester = value["semester"];
          controlSemester.text = _tmpIdSemester.toString();

          if(controlSemester.text.toString().compareTo("0") == 0){
            return dropdownIntSemester= "Any";
          }else if(controlSemester.text.toString().compareTo("1") == 0){
            return dropdownIntSemester = "1";
          }else if(controlSemester.text.toString().compareTo("2") == 0){
            return dropdownIntSemester = "2";
          }else if(controlSemester.text.toString().compareTo("3") == 0){
            return dropdownIntSemester = "3";
          }else if(controlSemester.text.toString().compareTo("4") == 0){
            return dropdownIntSemester = "4";
          }else if(controlSemester.text.toString().compareTo("5") == 0){
            return dropdownIntSemester = "5";
          }else if(controlSemester.text.toString().compareTo("6") == 0){
            return dropdownIntSemester = "6";
          }else if(controlSemester.text.toString().compareTo("7") == 0){
            return dropdownIntSemester = "7";
          }else if(controlSemester.text.toString().compareTo("8") == 0){
            return dropdownIntSemester = "8";
          }else if(controlSemester.text.toString().compareTo("9") == 0){
            return dropdownIntSemester = "9";
          }

        }catch(e){
          if(status != null){
            ShowMessage.functionShowMessage("${status}");
          }else{
            await ShowMessage.functionShowDialog("Not found you user", context);
            Navigator.of(_scaffoldKey.currentContext).pop();
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
            key: _scaffoldKey,
            appBar: status.toString().compareTo("You need to update information")!=0
              ? AppBar(
                  title: Text('Personal information',textAlign: TextAlign.center,),
                  backgroundColor: Colors.orange[600],
                  elevation: 0,
                  automaticallyImplyLeading: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () =>
                        Navigator.of(_scaffoldKey.currentContext).pop(),
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
                    ? FutureBuilder(
                      future: getstudentCode(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          if(snapshot.data != null) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 10,
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                                                handlerUserInfor("Full name", displayName),
                                                SizedBox(height: 30,),
                                                handlerUserInfor("Student code", matchesStudent.toUpperCase()),
                                                SizedBox(height: 30,),
                                                handlerUserUpdate("Phone",controlNumber,TextInputType.number,'Ex: 0836831237'),
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
                                                SizedBox(height: 30,),
                                                Row(
                                                  children: <Widget>[
                                                    SizedBox(width: 15,),
                                                    Text("Semester",style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold)),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only( left: 16.0,right: 16.0),
                                                  child: dropdownSemester(),
                                                ),
                                              ],
                                            ),),
                                        ),
                                        Expanded(
                                          flex: 0,
                                          child:  Container(
                                            margin: EdgeInsets.only(top: 55,right: 16,left: 11),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 52,
                                              child: RaisedButton(
                                                onPressed: () async {
                                                  if(validateMobile(controlNumber.text) != null){
                                                    setState(() {
                                                    });
                                                  }else{
                                                    setState(() {
                                                    });
                                                    // update userprofile
                                                    String _tmpNum = controlNumber.text;
                                                    String _tmpMajor = saveSynMajor;
                                                    String _tmpMSSV = matchesStudent;

                                                    String _tmpSemester;
                                                    if(dropdownIntSemester.compareTo("Any")== 0){
                                                      _tmpSemester = 0.toString();
                                                    }else{
                                                      _tmpSemester = dropdownIntSemester;
                                                    }

                                                    SharedPreferences sp = await SharedPreferences.getInstance();
                                                    String token = sp.getString("token_data");
                                                    decodedToken = JwtDecoder.decode(token);
                                                    int idUser = int.parse(decodedToken["sub"]);
                                                // check update info
                                                    var _tmpUpdate = await dao.updateInforUser(new UserProfileDTO(id: idUser,
                                                        studentCode: _tmpMSSV,phone: _tmpNum,major: _tmpMajor,
                                                        fullName: displayName,semester: _tmpSemester),);
                                                // update info for success then come back home
                                                    messageUpdate(_tmpUpdate);
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
                            );
                          }
                        }
                        return Center ();
                      })
                    : Center (
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(image: AssetImage("assets/images/tenor.gif"),width: 300,height: 300,),
                        ],
                      ),
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
    }else{
      isCheck = true;
      return null;
    }
  }

  //get info students
  Future<dynamic> getstudentCode() async {
    try {
      _tmpInfor = await UserProfileDAO().getInforUser();
      return _tmpInfor;
    }catch(e){
      // ShowMessage.functionShowDialog("Not found you user", context);
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
  Widget handlerUserUpdate(String tmpPhone, tmpController,type,String hint){
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
              TextFormField(
                keyboardType: type,
                controller: tmpController,
                decoration: InputDecoration(
                  hintText: hint,
                  suffixIcon: Icon(Icons.star,color: Colors.red,size: 10,),
                  errorText: validateMobile(tmpController.text),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // check user update information
  Future<Widget> messageUpdate(_tmpUpdate) async {
    // update when login first time with status != null
    if(_tmpUpdate.compareTo("Update successful")==0){
      await ShowMessage.functionShowDialog(_tmpUpdate,_scaffoldKey.currentContext);
      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(
          builder: (context) => HomePage(uid: uid)),(
          Route<dynamic> route) => false);
    }else{
      await ShowMessage.functionShowDialog(_tmpUpdate,_scaffoldKey.currentContext);
    }
  }

  // button dropdown Major
  dropdownMajor() {
    return DropdownButtonFormField<String>(
      disabledHint: Text('${dropdownValue}'),
      isExpanded: true,
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward,color: Colors.blue[500],),
      iconSize: 24,
      onChanged: (newValue)async{
        // setState(() {
          dropdownValue = newValue;
          if(dropdownValue.compareTo("Software Engineering") ==0){
            return saveSynMajor = "Software Engineering";
          }else if(dropdownValue.compareTo("Business Administration") ==0){
            return saveSynMajor = "Business Administration";
          }else if(dropdownValue.compareTo("English Language") ==0){
            return saveSynMajor = "English Language";
          }else if(dropdownValue.compareTo('Another Major') == 0){
            return saveSynMajor = "Another Major";
          }
        // });
      },
      items: <String>['Software Engineering','Business Administration','English Language','Another Major']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  // button dropdown semester
  dropdownSemester() {
    try {
      return DropdownButtonFormField<String>(
        disabledHint: Text('${dropdownIntSemester}'),
        isExpanded: true,
        value: dropdownIntSemester,
        icon: Icon(Icons.arrow_downward, color: Colors.blue[500],),
        iconSize: 24,
        onChanged: (newValue) async {
          // setState(() {
          dropdownIntSemester = newValue;
          // });
        },
        items: <String>['Any', '1', '2', '3', '4', '5', '6', '7', '8', '9',]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    }catch(e){
    }
  }
}
