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
    }else if(value == "Not Found Student Info"){
      return "Please update info first";
    }
    return "Event registration failed";
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

}