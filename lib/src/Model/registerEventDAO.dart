import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:designui/src/Model/userDTO.dart';

class RegisterEventDAO{
  // user register event
  Future registerEvents(RegisterEventsDTO dto, bool approval) async {
      ApiHelper _api = new ApiHelper();
      var json = await _api.postRegisEvent(dto, "api/registrations?ApprovalRequired=${approval}");
      if (json["isSuccess"] == true) {
        return "Register Successfully";
      }
      return "Register failed";
  }

  // cancel events when user register want to cancel
  Future cancelRegisEvents(String status, int idEvents) async {
    ApiHelper _api = new ApiHelper();
    var json = await _api.put(status, "api/registrations/${idEvents}");
    if (json != null) {
      return json["message"];
    }
    return null;
  }

  // check status this events user have not registered yet or register
  Future<String> statusRegis(int userId, int idEvents) async {
    try {
      dynamic json;
      ApiHelper _api = new ApiHelper();
      json = await _api.get("api/registrations?EventId=${idEvents}&StudentCode=${userId}");
      if (json["message"] == "Success") {
        return json["data"][0]["status"];
      }
      return null;
    }catch(e){
      return null;
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

  // list events page index history
  Future<dynamic> pageIndexHistory(String studentCode,int index) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/registrations?StudentCode=${studentCode}&PageIndex=${index}&PageSize=10");
    var eventJson = json["data"] as List;
    if (eventJson != null) {
      return eventJson.map((e) => UserDTO.fromJson(e)).toList();
    } else {
      return json;
    }
  }
  // list first events page index history
  Future<dynamic> pageFirstHistory(String studentCode) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/registrations?StudentCode=${studentCode}&PageIndex=1&PageSize=10");
    var eventJson = json["data"] as List;
    if (eventJson != null) {
      return eventJson.map((e) => UserDTO.fromJson(e)).toList();
    } else {
      return json;
    }
  }

}