import 'package:designui/src/Model/registerEventDAO.dart';

class RegisterVM{

  Future cancelRegisEvents(String idStudents) async {
    try {
      RegisterEventDAO _dao = new RegisterEventDAO();
      var value = await _dao.cancelRegisEvents(idStudents);
      if (value != null) {
        return "Hủy ký tham gia sự kiện thành công";
      }
    }catch(e){
      return "Lỗi đăng kí hủy tham gia";
    }
  }
}