import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:designui/src/Model/userDTO.dart';

class RegisterEventDAO{
  // user register event
  Future registerEvents(RegisterEventsDTO dto, bool approval) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.postRegisEvent(
          dto, "api/registrations?ApprovalRequired=${approval}");
      if (json["isSuccess"] == true) {
        return "Register Successfully";
      }
      return "Register failed";
    }catch(e){
      return "Not Found Student Info";
    }
  }

  // cancel events when user register want to cancel
  Future cancelRegisEvents(String status, int id, isCheckin) async {
    ApiHelper _api = new ApiHelper();
    var json = await _api.put(status, "api/registrations/${id}",isCheckin);
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
      json = await _api.get("api/registrations?EventId=${idEvents}&UserId=${userId}");
      if (json["message"] == "Success") {
        return json["data"]["items"][0]["status"];

      }
      return null;
    }catch(e){
      return null;
    }
  }

  // list events user register
  Future<dynamic> listEventHistory(int userId) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.get("api/registrations?UserId=${userId}&PageIndex=1&PageSize=100");
      var eventJson = json["data"]["items"] as List;
      if (eventJson != null) {
        return eventJson.map((e) => UserDTO.fromJson(e)).toList();
      } else {
        return json;
      }
    }catch(e){
    }
  }

  // list events page index history
  Future<dynamic> pageIndexHistory(int userId,int index) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/registrations?UserId=${userId}&PageIndex=${index}&PageSize=10");
    var eventJson = json["data"]["items"] as List;
    if (eventJson != null) {
      return eventJson.map((e) => UserDTO.fromJson(e)).toList();
    } else {
      return json;
    }
  }
  // list first events page index history
  Future<dynamic> pageFirstHistory(int userId) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.get(
          "api/registrations?UserId=${userId}&PageIndex=1&PageSize=10");
      var eventJson = json["data"]["items"] as List;
      if (eventJson != null) {
        return eventJson.map((e) => UserDTO.fromJson(e)).toList();
      } else {
        return json;
      }
    }catch(e){
    }
  }

  // get id when user register
  Future<dynamic> idOfEvent(int id) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/registrations?EventId=${id}");
    var eventDTO = json["data"]["items"][0]["id"];
    return eventDTO;
  }

}