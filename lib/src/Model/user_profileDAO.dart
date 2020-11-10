import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/user_profileDTO.dart';

class UserProfileDAO{
  Future<String> getInforProfile(UserProfileDTO dto) async{
    ApiHelper _api = new ApiHelper();
    dynamic response = await _api.putInfor(dto,"api/users/information");
    var json = response["message"];
    if(json != null){
      return json;
    }
    return null;
  }

}