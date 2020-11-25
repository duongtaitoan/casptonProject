import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/user_profileDTO.dart';

class UserProfileDAO{
  // update user profile
  Future<String> updateInforUser(UserProfileDTO dto,idUser) async{
    try {
      ApiHelper _api = new ApiHelper();
      dynamic response = await _api.putInfor(dto, "api/accounts/student/${idUser}");
      var json = response["message"];
      if (json != null) {
        return json;
      }
      return null;
    }catch(e){
      throw(e);
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
    return null;
  }

  // get student code
  Future<dynamic> getStudentCode(int idUser) async {
    ApiHelper _api = new ApiHelper();
    dynamic response = await _api.get("api/accounts/student/${idUser}");
    var json = response["data"]["studentCode"];
    if (json != null) {
      return json;
    }
    return null;
  }

}