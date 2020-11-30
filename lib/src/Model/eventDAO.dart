import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/eventDTO.dart';

class EventsDAO{
  // get event flow week
  Future<List<EventsDTO>> apiGetListEvents(now,isFuture) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events?StartedAt=${now}&EndedAt=${isFuture}");
    var eventJson = json["data"] as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }

  // get list event opening
  Future<List<EventsDTO>> getAllOpenning(status) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events?Status=${status}");
    var eventJson = json["data"] as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }

  // get api flow page index events anh status
  Future<List<EventsDTO>> pageIndex(int index,int page) async {
    ApiHelper _api = new ApiHelper();
    try {
      dynamic json = await _api.get("api/events?PageIndex=${index}&PageSize=${page}?Status=Opening");
      var eventJson = json["data"] as List;
      return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
    }catch(e){
    }
  }

  // get api flow page index events
  Future<List<EventsDTO>> pageFirstOpening(int index,String status) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events?Status=${status}&PageIndex=${index}&PageSize=5");
    var eventJson = json["data"] as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }

  // get pageFirst in viewAll events
  Future<List<EventsDTO>> viewAllPageFirst(int index) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events?Status=Opening&PageIndex=${index}&PageSize=20");
    var eventJson = json["data"] as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }

  // get events flow id events
  Future<dynamic> idEvents(int index) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events/${index}");
    var eventDTO = json["data"];
    return EventsDTO.fromJson(eventDTO);
  }

}