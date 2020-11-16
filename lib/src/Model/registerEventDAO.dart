import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:designui/src/Model/userDTO.dart';

class RegisterEventDAO{
  Future registerEvents(RegisterEventsDTO dto) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.postRegisEvent(dto, "api/registrations/");
      if (json != null) {
        return "Register Successfully";
      }
    }catch(e){
        return "Registered";
    }
  }

  // cancel events when user register want to cancel
  Future cancelRegisEvents(String idStudents) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.put(idStudents, "api/registrations/");
      if (json != null) {
        return "Hủy tham gia sự kiện thành công";
      }
    }catch(e){
      return "Lỗi đăng kí hủy tham gia";
    }
  }

  // get events user register or not
  Future<dynamic> getInfor(String studentCode, int idEvents) async {
    ApiHelper _api = new ApiHelper();
    dynamic json;
    try {
      json = await _api.get(
          "api/registrations?EventId=${idEvents}&StudentCode=${studentCode}");
      var tmp = json["message"];
      if (json["message"] == "Success") {
        return json["data"][0]["status"];
      } else {
        return tmp;
      }
    }catch(e){
      print('Error Registration :${e.toString()}');
    }
  }

  // list events user register
  Future<dynamic> listEventHistory(String studentCode) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/registrations?StudentCode=${studentCode}");
    var eventJson = json["data"] as List;
      if (eventJson != null) {
        return eventJson.map((e) => UserDTO.fromJson(e)).toList();
      } else {
        return json;
      }
  }

}