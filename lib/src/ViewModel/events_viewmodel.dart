import 'package:designui/src/Model/eventDAO.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:scoped_model/scoped_model.dart';

class EventsVM extends Model {
  int index = 0;
  int page = 5;
  bool isLoading = false;
  bool isAdd = false;
  List<EventsDTO> listEvent;
  var showToast;

  // get event opening
  static Future<List<EventsDTO>> getAllListEvents() async {
    try {
      EventsDAO dao = new EventsDAO();
      var listEvents = await dao.getAllOpenning("Opening");
      List<EventsDTO> saveEvents = new List<EventsDTO>();
      if(listEvents!= null){
        saveEvents.addAll(listEvents);
      }
      return saveEvents;
    } catch (e) {
    }
  }

  // get event opening
  Future<List<EventsDTO>> getListEventsOpening() async {
    try {
      EventsDAO dao = new EventsDAO();
      var listEvents = await dao.apiGetEventsStatus("OPEN_FOR_REGISTRATIONS");
      List<EventsDTO> saveEvents = new List<EventsDTO>();
      if(listEvents!= null){
        notifyListeners();
        saveEvents.addAll(listEvents);
      }
      return saveEvents;
    } catch (e) {
    }
  }

  // get event ongoing
  Future<List<EventsDTO>> getEventsOngoing() async {
    try {
      EventsDAO dao = new EventsDAO();
      var listEvents = await dao.apiGetEventsStatus("ONGOING");
      List<EventsDTO> saveEvents = new List<EventsDTO>();
      if(listEvents!= null){
        notifyListeners();
        saveEvents.addAll(listEvents);
      }
      return saveEvents;
    } catch (e) {
    }
  }

  // load more page events
  Future<void> changPageIndex() async {
    try {
      // isAdd load more
      isAdd = true;
      notifyListeners();
      index++;
      EventsDAO dao = new EventsDAO();
      // get next
      var listEvents = await dao.pageIndex(index);
        if (listEvents.toString() != null) {
        listEvent.addAll(listEvents);
      }
    } catch (e) {
      isAdd = false;
      notifyListeners();
      showToast = "No new event found";
    } finally {
      isAdd = false;
      notifyListeners();
    }
  }

  // get first 10 record upcoming for registrations events
  Future<void> getFirstIndex() async {
    try {
      isLoading = true;
      notifyListeners();
      EventsDAO dao = new EventsDAO();
      var listEvents = await dao.pageFirstOpening(0,"UPCOMING");
      listEvent = new List();
      if(listEvents.length != 0){
        listEvent.addAll(listEvents);
      }else{
        notifyListeners();
      }
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // event in week
  Future<List<EventsDTO>> eventInWeek(now,isFuture) async {
    try {
      EventsDAO dao = new EventsDAO();
      // var listEvents = await dao.apiGetListEvents("2021-02-08T23:00:00Z","2021-02-09T02:30:18Z");
      var listEvents = await dao.apiGetListEvents(now, isFuture);
      List<EventsDTO> saveEvents = new List<EventsDTO>();
      if (listEvents.isNotEmpty) {
        notifyListeners();
        saveEvents.addAll(listEvents);
        return saveEvents;
      }
    }catch(e){

    }
  }

  // loading event flow id user event
  Future<EventsDTO> getEventFlowId(int id) async{
    try {
      EventsDAO dao = new EventsDAO();
      var eventsDTO = await dao.idEvents(id);
      eventsDTO.toJson();
      return eventsDTO;
    }catch(e){
    }
  }

  // get hash notification
  // static Future<String> getIDHash() async {
  //   try {
  //     EventsDAO dao = new EventsDAO();
  //     return await dao.getIdHash();
  //   } catch (e) {
  //     log("Cannot get ID hash. Detailed: " + e);
  //   }
  // }
}
