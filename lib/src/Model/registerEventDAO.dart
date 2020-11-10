import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/userDTO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';

class RegisterEventDAO{
  Future registerEvents(RegisterEventsDTO dto) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.postRegisEvent(dto, "api/registrations/");
      if (json != null) {
        return "Đăng ký thành công";
      }
    }catch(e){
        return "Người dùng đã đăng ký sự kiện";
    }
  }

  // cancel events when user register want to cancel
  Future cancelRegisEvents(String idStudents) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.put(idStudents, "api/registrations/");
      if (json != null) {
        return "Hủy ký tham gia sự kiện thành công";
      }
    }catch(e){
      return "Lỗi đăng kí hủy tham gia";
    }
  }

  // get list event user register
  Future listEventsRegister(String idStudents) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.get("api/registrations/?????/${idStudents}");
      var eventsJson = json as List;
      return eventsJson.map((e) => UserDTO.fromJson(e)).toList();
    }catch(e){
      return 0;
    }
  }

  // get list event user Unapproved
  Future listEventsUnapproved(String idStudents) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.get("api/registrations/?????/${idStudents}");
      var eventsJson = json as List;
      return eventsJson.map((e) => UserDTO.fromJson(e)).toList();
    }catch(e){
      return 0;
    }
  }

  // get list event user Approved
  Future listEventsApproved(String idStudents) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.get("api/registrations/?????/${idStudents}");
      var eventsJson = json as List;
      return eventsJson.map((e) => UserDTO.fromJson(e)).toList();
    }catch(e){
      return 0;
    }
  }

  // get list event user on going
  Future listEventsOnGoing(String idStudents) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.get("api/registrations/?????/${idStudents}");
      var eventsJson = json as List;
      return eventsJson.map((e) => UserDTO.fromJson(e)).toList();
    }catch(e){
      return 0;
    }
  }
}