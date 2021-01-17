import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/Helper/show_message.dart';

class EventsDAO{
  // get event flow week
  Future<List<EventsDTO>> apiGetListEvents(now,isFuture) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.postWeekEvents(now,isFuture,"OPEN_FOR_REGISTRATIONS","api/events/find-by-query");
    var eventJson = json["content"] as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }

  // get event flow status
  Future<List<EventsDTO>> apiGetEventsStatus(String status) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.postEvents(status,null,"api/events/find-by-query");
    var eventJson = json["content"] as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }

  // get list event opening
  Future<List<EventsDTO>> getAllOpenning(status) async {
    ApiHelper _api = new ApiHelper();
    // dynamic json = await _api.get("api/events?Status=${status}");
    dynamic json = await _api.get("api/events");
    var eventJson = json as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }

  // get api flow page index events anh status
  Future<List<EventsDTO>> pageIndex(int index) async {
    ApiHelper _api = new ApiHelper();
    try {
      dynamic json = await _api.postEvents("OPEN_FOR_REGISTRATIONS",index,"api/events/find-by-query");
      var eventJson = json["content"] as List;
      if(eventJson.isNotEmpty){
        return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
      }
      return null;
    }catch(e){
      throw e.toString();
    }
  }

  // get api flow page index events
  Future<List<EventsDTO>> pageFirstOpening(int index,String status) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.postEvents(status,index,"api/events/find-by-query");
    var eventJson =  await json["content"] as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }

  // get pageFirst in viewAll events
  Future<List<EventsDTO>> viewAllPageFirst(int index,context) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.postEvents("OPEN_FOR_REGISTRATIONS",index,"api/events/find-by-query");
      var eventJson = json["content"] as List;
      if(json["errorCode"] == 500){
        return null;
      }
      return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
    }catch(e){
      // throw e.toString();
      // RegExp pattern = new RegExp('([0-9]{3,4})');
      // var a = pattern.stringMatch(e.toString());
      // if(int.parse(a) == 404){
      //   await ShowMessage.functionShowDialog("No events found", context);
      // }else if(int.parse(a) == 500){
      //   await ShowMessage.functionShowDialog("Server error", context);
      // }
    }
  }

  // get events flow id events
  Future<dynamic> idEvents(int idEvent) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.getIdEvent("api/events/${idEvent}");
    return EventsDTO.fromJson(json);
  }

  // get hash notification in server
  Future<dynamic> getNotification() async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.getHashNoti("api/notifications/my-id-hash");
    return json;
  }
}