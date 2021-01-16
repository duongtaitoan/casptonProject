import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/Model/registerEventDAO.dart';
import 'package:designui/src/Model/userDTO.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryVM extends Model{
  int index = 0;
  bool isLoading = false;
  bool isAdd = false;
  List<EventsDTO> listEvent;
  var mgs;
  var message;

  // get list events flow status action
  Future<List<UserDTO>> getFlowStatus(String status) async {
    try {
      var listEvents = await RegisterEventDAO().statusEvents(status);
      List<UserDTO> saveEvents = new List<UserDTO>();
      for (int i = 0; i < listEvents.length; i++) {
        if (listEvents[i].status == status) {
          saveEvents.add(listEvents[i]);
          }
        }
        return saveEvents;
    } catch (e) {
    }
  }

  // get list events user register history
  Future<List<EventsDTO>> getListEventHistory() async {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // String token = sp.getString("token_data");
    // var decodedToken= JwtDecoder.decode(token);
    var listEvent = await RegisterEventDAO().eventIsCompleted("UPCOMING");
    return listEvent;
  }

  // get first 10 record for history events
  Future<void> pageFristHistory(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      var listEvents = await RegisterEventDAO().pageFirstHistory("UPCOMING",index,context);
      listEvent = new List();
      if(listEvents.toString().compareTo("No events found")==0 || listEvents.toString().compareTo("Server error")==0){
        SharedPreferences spf = await SharedPreferences.getInstance();
        spf.setString("sms", listEvents);
        notifyListeners();
      }
      else{
        listEvent.addAll(listEvents);
      }
    }catch (e) {
      throw e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // load more page events
  Future<void> pageHistoryIndex() async {
    try {
      // isAdd load more
      isAdd = true;
      notifyListeners();
      index++;
      // SharedPreferences sp = await SharedPreferences.getInstance();
      // String token = sp.getString("token_data");
      // var decodedToken= JwtDecoder.decode(token);

      RegisterEventDAO dao = new RegisterEventDAO();
      var listEvents = await dao.pageIndexHistory("UPCOMING",index);
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

