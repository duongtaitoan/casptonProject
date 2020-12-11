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
  bool isCheck = false;

  var _tmpInfor;
  var matchesStudent;
  var saveSynMajor;

  _UserProfilePageState(this.uid,this.status);
  final TextEditingController controlNumber = TextEditingController();
  TextEditingController controlMajor = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState(){
    RegExp pattern = new RegExp('([se|sa|sb|ss|SS|SE|SA|SB]{2})([0-9]{5,8})');
    var _tmpStudentCode = uid.email.split("@")[0];
    matchesStudent = pattern.stringMatch(_tmpStudentCode);
    dropdownValue="Information System";

    dao = new UserProfileDAO();
    super.initState();
    try {
      getstudentCode().then((value) {
        try {
          controlMajor.text = value["major"];
          if(controlMajor.text.toString().compareTo("SE")==0){
            dropdownValue="Information System";
          }else if(controlMajor.text.toString().compareTo("SS")==0){
            dropdownValue="Business Administration";
          }else if(controlMajor.text.toString().compareTo("SA")==0){
            dropdownValue="English Language";
          }
          controlNumber.text = value["phoneNumber"];
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
                future: Future.delayed(Duration(milliseconds: 2000),),
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
                                              ],
                                            ),),
                                        ),
                                        Expanded(
                                          flex: 0,
                                          child:  Container(
                                            margin: EdgeInsets.only(top: 135,right: 16,left: 11),
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

                                                    var _tmpUpdate = await dao.updateInforUser(new UserProfileDTO(
                                                        studentCode: _tmpMSSV,phone: _tmpNum,major: _tmpMajor,
                                                        fullname: displayName),int.parse(decodedToken["userId"]));
                                                    // check info
                                                    checkUpdateInfo(_tmpUpdate);
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
                        return Center (
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image(image: AssetImage("assets/images/tenor.gif"),width: 300,height: 300,),
                            ],
                          ),
                        );
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

  //get studentsCode
  Future<dynamic> getstudentCode() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token_data");
      decodedToken = JwtDecoder.decode(token);
      _tmpInfor = await UserProfileDAO().getInforUser(int.parse(decodedToken["userId"]));
      return _tmpInfor;
    }catch(e){
      ShowMessage.functionShowDialog("Server error", context);
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
  Future<Widget> checkUpdateInfo(_tmpUpdate) async {
    // update when login first time with status != null
    if(_tmpUpdate.compareTo("Update successful")==0){
      await ShowMessage.functionShowMessage(_tmpUpdate);
      await Future.delayed(Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(
            builder: (context) => HomePage(uid: uid)),(
            Route<dynamic> route) => false);
      });
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
        setState(() {
          dropdownValue = newValue;
          if(dropdownValue.compareTo("Information System") ==0){
            return saveSynMajor = "SE";
          }else if(dropdownValue.compareTo("Business Administration") ==0){
            return saveSynMajor = "SS";
          }else if(dropdownValue.compareTo("English Language") ==0){
            return saveSynMajor = "SA";
          }
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
