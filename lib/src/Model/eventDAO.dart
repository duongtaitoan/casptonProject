import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/Helper/show_message.dart';


class EventsDAO{
  // get event flow week
  Future<List<EventsDTO>> apiGetListEvents(now,isFuture) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events?StartedAt=${now}&EndedAt=${isFuture}&Status=Opening");
    var eventJson = json["data"]["items"] as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }

  // get list event opening
  Future<List<EventsDTO>> getAllOpenning(status) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events?Status=${status}");
    var eventJson = json["data"]["items"] as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }

  // get api flow page index events anh status
  Future<List<EventsDTO>> pageIndex(int index,int page) async {
    ApiHelper _api = new ApiHelper();
    try {
      dynamic json = await _api.get("api/events?PageIndex=${index}&PageSize=${page}?Status=Opening");
      var eventJson = json["data"]["items"] as List;
      return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
    }catch(e){
    }
  }

  // get api flow page index events
  Future<List<EventsDTO>> pageFirstOpening(int index,String status) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events?Status=${status}&PageIndex=${index}&PageSize=5");
    var eventJson = json["data"]["items"] as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }

  // get pageFirst in viewAll events
  Future<List<EventsDTO>> viewAllPageFirst(int index,context) async {
    try {
      ApiHelper _api = new ApiHelper();
      dynamic json = await _api.get(
          "api/events?Status=Opening&PageIndex=${index}&PageSize=20");
      var eventJson = json["data"]["items"] as List;
      return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
    }catch(e){
      RegExp pattern = new RegExp('([0-9]{3,4})');
      var a = pattern.stringMatch(e.toString());
      if(int.parse(a) == 404){
        await ShowMessage.functionShowDialog("Not found events", context);
      }else if(int.parse(a) == 500){
        await ShowMessage.functionShowDialog("Server error", context);
      }
    }
  }

  // get events flow id events
  Future<dynamic> idEvents(int index) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events/${index}");
    var eventDTO = json["data"];
    return EventsDTO.fromJson(eventDTO);
  }

}