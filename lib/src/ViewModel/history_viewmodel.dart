import 'package:designui/src/Model/registerEventDAO.dart';
import 'package:designui/src/Model/userDAO.dart';
import 'package:designui/src/Model/userDTO.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryVM{
  // get list events flow status
  Future<List<UserDTO>> getFlowStatus(String status) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token_data");
      var decodedToken= JwtDecoder.decode(token);
      var listEvents = await RegisterEventDAO().listEventHistory(decodedToken["studentCode"]);
      List<UserDTO> saveEvents = new List<UserDTO>();
      for (int i = 0; i < listEvents.length; i++) {
        if(listEvents[i].status == status) {
          saveEvents.add(listEvents[i]);
        }
      }
      return saveEvents;
    } catch (e) {
      throw (e);
    }
  }

  // get all list history of user
  Future<List<UserDTO>> getListStatus(bool check) async {
    try {
      UserDAO dao = new UserDAO();
      var listEvents = await dao.getListStatusEvents(check);
      List<UserDTO> saveEvents = new List<UserDTO>();
      for (int i = 1; i < listEvents.length; i++) {
        saveEvents.add(listEvents[i]);
      }
      return saveEvents;
    } catch (e) {
      throw (e);
    }
  }

  // get list events user register
  Future<List<UserDTO>> getListEventHistory() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token_data");
    var decodedToken= JwtDecoder.decode(token);
    var listEvent = await RegisterEventDAO().listEventHistory(decodedToken["studentCode"]);
    return listEvent;
  }
}

