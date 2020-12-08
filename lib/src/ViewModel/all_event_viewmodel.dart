import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/Model/eventDAO.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class ViewAllVM extends Model{
  int index = 1;
  int page = 20;
  bool isLoading = false;
  bool isAdd = false;
  List<EventsDTO> listEvent;
  var mgs;

  // get first 20 record for history events
  Future<void> pageFrist(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      EventsDAO dao = new EventsDAO();
      var listEvents = await dao.viewAllPageFirst(index);
      listEvent = new List();

      if(listEvents.toString() != null){
        listEvent.addAll(listEvents);
      }
    } catch (e) {
      ShowMessage.functionShowDialog("Server error", context);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // load more page events
  Future<void> pageIndex() async {
    try {
      // isAdd load more
      isAdd = true;
      notifyListeners();
      index++;

      EventsDAO dao = new EventsDAO();
      var listEvents = await dao.pageIndex(index, page);
      // get next
      if (listEvents.toString() != null) {
        listEvent.addAll(listEvents);
      }
    } catch (e) {
      isAdd = false;
      notifyListeners();
      mgs = "No Events";
    } finally {
      isAdd = false;
      notifyListeners();
    }
  }

}