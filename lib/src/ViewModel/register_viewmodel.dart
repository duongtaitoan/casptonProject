import 'package:designui/src/Model/registerEventDAO.dart';
import 'package:designui/src/Model/registerEventDTO.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterVM extends Model{
  // user register event
  Future register(int idEvent) async {
    RegisterEventDAO _dao = new RegisterEventDAO();
    var value = await _dao.registerEvents(idEvent);
    if (value.toString().isNotEmpty) {
      return value;
    }
    return value;
  }

  // cancel event
  Future updateStatusEvent(int idEvent) async {
    RegisterEventDAO _dao = new RegisterEventDAO();
    var value = await _dao.cancelRegisEvents(idEvent);
    if (value != null) {
      return value;
    }
    return "Canceled event successful";
  }

  // check status this events user have not registered yet or register
  Future<String> statusRegisterEvent(int idEvents) async {
    RegisterEventDAO _dao = new RegisterEventDAO();
    var value = await _dao.statusRegis(idEvents);
    if(value.isNotEmpty){
      return value;
    }
  }

  // check status events
  Future<String> statusEventEvent(idEvent) async {
    try {
      RegisterEventDAO _dao = new RegisterEventDAO();
      var value = await _dao.statusEvent(idEvent);
      return value;
    }catch(e){
    }
  }

  //get locaction of event
  Future<List<dynamic>> getLoactionEvent(String nameLocation)async{
    RegisterEventDAO _dao = new RegisterEventDAO();
    var value = await _dao.locationEvent(nameLocation);
    if (value != null) {
      return value;
    }
    return null;
  }

}