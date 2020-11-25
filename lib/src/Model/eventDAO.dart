import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/eventDTO.dart';

class EventsDAO{
  // get 100 data api to pagesize
  Future<List<EventsDTO>> apiGetListEvents() async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events?pageSize=100&pageIndex=1");
    var eventJson = json["data"] as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }

  // get api flow page index events anh status
  Future<List<EventsDTO>> pageIndex(int index) async {
    ApiHelper _api = new ApiHelper();
    try {
      dynamic json = await _api.get("api/events?PageIndex=${index}&PageSize=5?Status=Opening");
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

  // get api events flow id events
  Future<dynamic> idEvents(int index) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events/${index}");
    var eventDTO = json["data"];
    return EventsDTO.fromJson(eventDTO);
  }

}