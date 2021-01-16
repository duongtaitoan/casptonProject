import 'package:designui/src/Helper/show_message.dart';
import 'package:designui/src/Model/eventDAO.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class ViewAllVM extends Model{
  int index = 0;
  int page = 10;
  bool isLoading = false;
  bool isAdd = false;
  List<EventsDTO> listEvent;
  var mgs;

  // get first 10 record for history events
  Future<void> pageFrist(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      EventsDAO dao = new EventsDAO();

      var listEvents = await dao.viewAllPageFirst(index,context);
      listEvent = new List();
      if(listEvents != null) {
        if (listEvents.length != 0) {
          listEvent.addAll(listEvents);
        } else {
          mgs = "No new event found";
          notifyListeners();
        }
      }else{
        mgs = "No new event found";
        notifyListeners();
      }
    } catch (e) {
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
      var listEvents = await dao.pageIndex(index);
      // get next
      if (listEvents.toString() != null) {
        listEvent.addAll(listEvents);
      }
    } catch (e) {
      isAdd = false;
      notifyListeners();
      mgs = "No new event found";
    } finally {
      isAdd = false;
      notifyListeners();
    }
  }

}