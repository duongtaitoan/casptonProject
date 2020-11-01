import 'package:designui/src/Model/eventDAO.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:intl/intl.dart';


class EventsVM {
  static var now = DateTime.now();
  static DateFormat sqlDF = DateFormat('yyyy-MM-ddTHH:mm:ss');
  static DateFormat converdtf = DateFormat('yyyy-MM-dd HH:mm:ss');

  static Future<List<EventsDTO>> getEventsPending() async {
    try {
      EventsDAO dao = new EventsDAO();
      var listEvents = await dao.apiGetListEvents();
      List<EventsDTO> saveEvents = new List<EventsDTO>();
      for (int i = 0; i < listEvents.length; i++) {
        if (listEvents[i].status == "Pending") {
          saveEvents.add(listEvents[i]);
        }
      }
      return saveEvents;
    }catch(e){
      throw(e);
    }
  }

  static Future<List<EventsDTO>> getEventsHistory() async {
    try {
      EventsDAO dao = new EventsDAO();
      var listEvents = await dao.apiGetListEvents();
      List<EventsDTO> saveEvents = new List<EventsDTO>();
      for (int i = 0; i < listEvents.length; i++) {
        // conver Time and check with time event if time current before then show this events
        DateTime tmpTime = sqlDF.parse(listEvents[i].startedAt);
        DateTime converDateEvent = converdtf.parse(tmpTime.toString());
        //add house finish events
        if (listEvents[i].status == "Active" && now.isAfter(converDateEvent)) {
          saveEvents.add(listEvents[i]);
        }
      }
      return saveEvents;
    }catch(e){
      throw(e);
    }
  }

  static Future<List<EventsDTO>> getEventsActive() async {
    try {
      EventsDAO dao = new EventsDAO();
      var listEvents = await dao.apiGetListEvents();
      List<EventsDTO> saveEvents = new List<EventsDTO>();
      for (int i = 0; i < listEvents.length; i++) {
        // conver Time and check with time event if time current before then show this events
        DateTime tmpTime = sqlDF.parse(listEvents[i].startedAt);
        DateTime converDateEvent = converdtf.parse(tmpTime.toString());
        //add house finish events
        if (listEvents[i].status == "Active" && now.isAfter(converDateEvent)) {
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
      for (int i = 1; i < listEvents.length; i++) {
        saveEvents.add(listEvents[i]);
      }
      return saveEvents;
    } catch (e) {
      throw (e);
    }
  }


   Future<List<EventsDTO>> testEventAll() async {
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
