import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/user_profileDTO.dart';

class UserProfileDAO{
  // update user profile
  Future<String> updateInforUser(UserProfileDTO dto) async{
    try {
      ApiHelper _api = new ApiHelper();
      dynamic response = await _api.putInfor(dto, "oauth/profile");
      if (response >= 200 && response <= 206) {
        return "Update successful";
      }else{
        return "Update info failed";
      }
    }catch(e){
      return "Update info failed";
    }
  }

  // get user profile
  Future<dynamic> getInforUser() async {
    ApiHelper _api = new ApiHelper();
    dynamic response = await _api.get("oauth/profile");
    // dynamic response = await _api.getProfile("profile");
    var json = response;
    if (json != null) {
      return json;
    }
    return null;
  }

  // get user profile
  Future<dynamic> deleteMyAccount() async {
    ApiHelper _api = new ApiHelper();
    dynamic response = await _api.deleteYourAccount("oauth/profile/delete-account");
    if (response != null) {
      return response;
    }
    return null;
  }
}