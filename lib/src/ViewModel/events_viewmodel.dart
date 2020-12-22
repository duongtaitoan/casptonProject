import 'package:designui/src/Model/eventDAO.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:scoped_model/scoped_model.dart';

class EventsVM extends Model {
  int index = 1;
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

  // load more page events
  Future<void> changPageIndex() async {
    try {
      // isAdd load more
      isAdd = true;
      notifyListeners();
      index++;
      EventsDAO dao = new EventsDAO();
      // get next
      var listEvents = await dao.pageIndex(index,page);
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

  // get first 5 record upcoming events
  Future<void> getFirstIndex() async {
    try {
      isLoading = true;
      notifyListeners();
      EventsDAO dao = new EventsDAO();
      var listEvents = await dao.pageFirstOpening(index,"Opening");
      listEvent = new List();
      if(listEvents.toString() != null){
        listEvent.addAll(listEvents);
      }
    } catch (e) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // event openning in week
  static Future<List<EventsDTO>> eventInWeek(now,isFuture) async {
    EventsDAO dao = new EventsDAO();
    var listEvents = await dao.apiGetListEvents(now,isFuture);
    if(listEvents.isNotEmpty) {
      List<EventsDTO> saveEvents = new List<EventsDTO>();
      saveEvents.addAll(listEvents);
      return saveEvents;
    }else{
      return null;
    }
  }

  // loading event flow id user event
  Future<EventsDTO> getEventFlowId(int id) async{
    try {
      EventsDAO dao = new EventsDAO();
      EventsDTO eventsDTO = await dao.idEvents(id);
      eventsDTO.toJson();
      return eventsDTO;
    }catch(e){
    }
  }
}
