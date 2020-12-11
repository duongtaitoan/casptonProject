import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/user_profileDTO.dart';

class UserProfileDAO{
  // update user profile
  Future<String> updateInforUser(UserProfileDTO dto,idUser) async{
    var json;
    try {
      ApiHelper _api = new ApiHelper();
      dynamic response = await _api.putInfor(dto, "api/accounts/student/${idUser}");
      json = response["message"];
      if (response["isSuccess"] == true) {
        return json;
      }
    }catch(e){
      return "Server error";
    }
  }

  // get user profile
  Future<dynamic> getInforUser(int idUser) async {
    ApiHelper _api = new ApiHelper();
    dynamic response = await _api.get("api/accounts/student/${idUser}");
    var json = response["data"];
    if (json != null) {
      return json;
    }
    return idUser;
  }

  // get student code
  Future<dynamic> getStudentCode(int idUser) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic response = await _api.get("api/accounts/student/${idUser}");
      var json = response["data"]["studentCode"];
      if (json != null) {
        return json;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}