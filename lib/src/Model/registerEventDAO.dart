import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/Model/locationDTO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:designui/src/Model/userDTO.dart';
import 'package:designui/src/Helper/show_message.dart';

class RegisterEventDAO{
  // user register event
  Future registerEvents(int idEvent) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.getIdEvent("api/events/${idEvent}/register");
      if(json['errorCode'] == 403 || json['errorCode'] == 404){
        return json["message"];
      }else if(json['errorCode'] == 0){
        return json["message"];
      }else if(json['errorCode'] == 500){
        return "Register failed";
      }else{
        return "Register Successfully";
      }
    }catch(e){
      // if(e.toString().contains("Student already register duplicate time duration event")){
      //   return "Student already register duplicate time duration event";
      // }else if(e.toString().contains("Student already registed this event")){
      //   return "Student already registed this event";
      // }else if(e.toString().contains("Student does not exist")){
      //   return "Student does not exist";
      // }
    }
  }

  // cancel events when user register want to cancel
  Future cancelRegisEvents(int id) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.getIdEvent("api/events/${id}/cancel-registration");
    if(json["errorCode"] == 0){
      return json["message"];
    }
    return null;
  }

  // check status this events user have not registered yet or register
  Future<String> statusRegis(int idEvents) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.getIdEvent("api/events/${idEvents}/registrations/me");
      if(json.toString().length == 2){
        return "Can register event";
      }else if(json["errorCode"] == 404){
        return "You have not registered for this event before.";
      }
      return json['status'];
    }catch(e){
      return null;
    }
  }

  // check status this events user have not registered yet or register
  Future<String> statusEvent(int idEvent) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.getIdEvent("api/events/${idEvent}");
      return json['status'];
    }catch(e){
    }
  }

  // list events flow status
  Future<dynamic> statusEvents(String status) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.postEventsByStatus(status,"api/registrations/find-by-query");
      var eventJson = json["content"] as List;
      if (eventJson.isNotEmpty) {
        return eventJson.map((e) => UserDTO.fromJson(e)).toList();
      } else {
        return json;
      }
    }catch(e){
    }
  }

  // list events history is completed user
  Future<dynamic> eventIsCompleted(String registrationStatus) async {
    try {
      ApiHelper _api = new ApiHelper();
      // dynamic json = await _api.get("api/registrations?EventStatus=${registrationStatus}&UserId=${userId}&PageIndex=1&PageSize=100");
      dynamic json = await _api.postEvents(registrationStatus,null,"api/events/find-by-query");
      var eventJson = json["content"] as List;
      if (eventJson != null) {
        return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
      } else {
        return json;
      }
    }catch(e){
    }
  }

  // list events page index history
  Future<dynamic> pageIndexHistory(String registrationStatus,int index) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.postEvents(registrationStatus,index,"api/events/find-by-query");
    var eventJson = json["content"] as List;
    if (eventJson.isNotEmpty) {
      return eventJson.map((e) => UserDTO.fromJson(e)).toList();
    } else {
      return json;
    }
  }

  // list first events page index history
  Future<dynamic> pageFirstHistory(String registrationStatus,int index,context) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.postEvents(registrationStatus,index,"api/events/find-by-query");
      var eventJson = json["content"] as List;
      if (eventJson.isNotEmpty ) {
        return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
      }else{
        return null;
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

  // get location of event
  Future locationEvent(String nameLocation) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.postLocation(nameLocation, "api/locations/find-by-query",);
    var location = json["content"] as List;
    return location;
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