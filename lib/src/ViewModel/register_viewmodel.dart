import 'package:designui/src/Model/registerEventDAO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterVM extends Model{
  // user register event
  Future register(RegisterEventsDTO dto,bool approval) async {
    RegisterEventDAO _dao = new RegisterEventDAO();
    var value = await _dao.registerEvents(dto,approval);
    if (value == "Register Successfully") {
      return value;
    }else{
      return value;
    }
    // return "Event registration failed";
  }

  // cancel event
  Future updateStatusEvent(String status,int id,isCheckin) async {
    RegisterEventDAO _dao = new RegisterEventDAO();
    var value = await _dao.cancelRegisEvents(status,id,isCheckin);
    if (value != null) {
      return value;
    }
    return "You can not cancel this event";
  }

  // check status this events user have not registered yet or register
  Future<String> statusRegisterEvent(int userId, int idEvents) async {
    RegisterEventDAO _dao = new RegisterEventDAO();
    var value = await _dao.statusRegis(userId, idEvents);
    if(value != null){
      return value;
    }
    return "this event you have not registered yet";
  }

  //get locaction of event
  Future<List<dynamic>> getLoactionEvent(int idOfEvent)async{
    RegisterEventDAO _dao = new RegisterEventDAO();
    var value = await _dao.locationEvent(idOfEvent);
    if (value != null) {
      return value;
    }
    return null;
  }

}