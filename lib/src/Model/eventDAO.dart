import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/eventDTO.dart';

class EventsDAO{
  Future<List<EventsDTO>> apiGetListEvents() async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.get("api/events?pageSize=10&pageIndex=1");
    var eventJson = json["data"] as List;
    return eventJson.map((e) => EventsDTO.fromJson(e)).toList();
  }
}