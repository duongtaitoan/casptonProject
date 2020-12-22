import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/locationDTO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:designui/src/Model/userDTO.dart';
import 'package:designui/src/Helper/show_message.dart';

class RegisterEventDAO{
  // user register event
  Future registerEvents(RegisterEventsDTO dto, bool approval) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.postRegisEvent(dto, "api/registrations?ApprovalRequired=${approval}");
      if (json["isSuccess"] == true) {
        return "Register Successfully";
      }else{
        return json["message"];
      }
    }catch(e){
      if(e.toString().contains("Student already register duplicate time duration event")){
        return "Student already register duplicate time duration event";
      }else if(e.toString().contains("Student already registed this event")){
        return "Student already registed this event";
      }else if(e.toString().contains("Student does not exist")){
        return "Student does not exist";
      }
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
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.get("api/registrations?EventId=${idEvents}&UserId=${userId}");
      if (json["message"] == "Success") {
        return json["data"]["items"][0]["status"];
      }
    }catch(e){
      return null;
    }
  }

  // list events flow status
  Future<dynamic> statusEvents(int userId) async {
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

  // list events history is completed user
  Future<dynamic> eventIsCompleted(String registrationStatus,int userId) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.get("api/registrations?EventStatus=${registrationStatus}&UserId=${userId}&PageIndex=1&PageSize=100");
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
  Future<dynamic> pageIndexHistory(String registrationStatus,int userId,int index) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/registrations?EventStatus=${registrationStatus}&UserId=${userId}&PageIndex=${index}&PageSize=10");
    var eventJson = json["data"]["items"] as List;
    if (eventJson != null) {
      return eventJson.map((e) => UserDTO.fromJson(e)).toList();
    } else {
      return json;
    }
  }

  // list first events page index history
  Future<dynamic> pageFirstHistory(String registrationStatus,int userId,context) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.get("api/registrations?EventStatus=${registrationStatus}&UserId=${userId}&PageIndex=1&PageSize=10");
      var eventJson = json["data"]["items"] as List;
      if (eventJson != null) {
        return eventJson.map((e) => UserDTO.fromJson(e)).toList();
      }
    }catch(e){
      RegExp pattern = new RegExp('([0-9]{3,4})');
      var a = pattern.stringMatch(e.toString());
      if(int.parse(a) == 404){
        await ShowMessage.functionShowDialog("No events found", context);
        return "No events found";
      }else if(int.parse(a) == 500){
        await ShowMessage.functionShowDialog("Server error", context);
        return "Server error";
      }
    }
  }

  // get id when user register
  Future<dynamic> idOfEvent(int id) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/registrations?EventId=${id}");
    var eventDTO = json["data"]["items"][0]["id"];
    return eventDTO;
  }

  // get location of user by id event
  Future locationEvent(int id) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events/${id}");
    var location = json["data"]["locations"] as List;
    return location.map((e) => LocationDTO.fromJson(e)).toList();
  }

  // get status checkIn  of user
  Future<bool> statusCheckIn(int userId, int idEvents,String statusRegisEvent) async {
    try {
      dynamic json;
      ApiHelper _api = new ApiHelper();
      json = await _api.get("api/registrations?EventId=${idEvents}&UserId=${userId}&EventStatus=${statusRegisEvent}");
      if (json["message"] == "Success") {
        return json["data"]["items"][0]["checkedIn"];
      }
    }catch(e){
      return false;
    }
  }

}