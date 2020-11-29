import 'package:designui/src/Model/registerEventDAO.dart';
import 'package:designui/src/Model/userDTO.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryVM extends Model{
  int index = 1;
  bool isLoading = false;
  bool isAdd = false;
  List<UserDTO> listEvent;
  var mgs;

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
    var listEvent = await RegisterEventDAO().listEventHistory(decodedToken["studentCode"]);
    return listEvent;
  }

  // get first 10 record for history events
  Future<void> pageFristHistory() async {
    try {
      isLoading = true;
      notifyListeners();
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token_data");
      var decodedToken= JwtDecoder.decode(token);

      RegisterEventDAO dao = new RegisterEventDAO();
      var listEvents = await dao.pageFirstHistory(decodedToken["studentCode"]);
      listEvent = new List();
      if(listEvents.toString() != null){
        listEvent.addAll(listEvents);
      }
    } catch (e) {
      mgs("The system is update");
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
      var listEvents = await dao.pageIndexHistory(decodedToken["studentCode"],index);
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

