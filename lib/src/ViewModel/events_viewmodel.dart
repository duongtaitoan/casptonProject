import 'package:designui/src/Model/eventDAO.dart';
import 'package:designui/src/Model/eventDTO.dart';

// if status == pending => show
class EventsVM {
  static Future<List<EventsDTO>> getEventsPending() async {
    try {
      EventsDAO dao = new EventsDAO();
      var listEvents = await dao.apiGetListEvents();
      List<EventsDTO> saveEvents = new List<EventsDTO>();
      for (int i = 0; i < listEvents.length; i++) {
        if (listEvents[i].status == "Active") {
          saveEvents.add(listEvents[i]);
        }
      }
      return saveEvents;
    } catch (e) {
      throw (e);
    }
  }

  static Future<List<EventsDTO>> getAllListEvents() async {
    try {
      EventsDAO dao = new EventsDAO();
      var listEvents = await dao.apiGetListEvents();
      List<EventsDTO> saveEvents = new List<EventsDTO>();
      for (int i = 0; i < listEvents.length; i++) {
        saveEvents.add(listEvents[i]);
      }
      return saveEvents;
    } catch (e) {
      throw (e);
    }
  }
}
