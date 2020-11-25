import 'package:designui/src/Model/eventDAO.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class EventsVM extends Model {
  static var now = DateTime.now();
  static DateFormat sqlDF = DateFormat('yyyy-MM-ddTHH:mm:ss');
  static DateFormat converdtf = DateFormat('yyyy-MM-dd HH:mm:ss');

  int index = 1;
  bool isLoading = false;
  bool isAdd = false;
  List<EventsDTO> listEvent;
  var showToast;
  // get 100 events in db
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
      showToast = "No Events";
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
      throw (e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // event to on going
  static Future<List<EventsDTO>> getEventsOnGoing() async {
    EventsDAO dao = new EventsDAO();
    var listEvents = await dao.apiGetListEvents();
    if(listEvents.isNotEmpty) {
      List<EventsDTO> saveEvents = new List<EventsDTO>();
      for (int i = 0; i < listEvents.length; i++) {
        if (listEvents[i].status == "On going") {
          saveEvents.add(listEvents[i]);
        }
      }
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
      return eventsDTO;
    }catch(e){
    }
  }
}
