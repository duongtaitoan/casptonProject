import 'package:designui/src/Model/eventDAO.dart';
import 'package:designui/src/Model/eventDTO.dart';
import 'package:designui/src/Model/registerEventDAO.dart';
import 'package:designui/src/Model/userDTO.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryVM extends Model{
  int index = 1;
  bool isLoading = false;
  bool isAdd = false;
  List<UserDTO> listEvent;
  var mgs;
  var message;

  // get list events flow status
  Future<List<UserDTO>> getFlowStatus(String status) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token_data");
      var decodedToken= JwtDecoder.decode(token);
      var listEvents = await RegisterEventDAO().listEventHistory(int.parse(decodedToken["userId"]));
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

  // get list events user register
  Future<List<UserDTO>> getListEventHistory() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    var decodedToken= JwtDecoder.decode(token);
    var listEvent = await RegisterEventDAO().listEventHistory(int.parse(decodedToken["userId"]));
    return listEvent;
  }

  // get first 10 record for history events
  Future<void> pageFristHistory(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token_data");
      var decodedToken= JwtDecoder.decode(token);
      var listEvents;
      listEvents = await RegisterEventDAO().pageFirstHistory("Completed",int.parse(decodedToken["userId"]),context);
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
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token_data");
      var decodedToken= JwtDecoder.decode(token);

      RegisterEventDAO dao = new RegisterEventDAO();
      var listEvents = await dao.pageIndexHistory("Completed",int.parse(decodedToken["userId"]),index);
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

