import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/registerEventDTO.dart';

class RegisterEventDAO{
  Future registerEvents(RegisterEventsDTO dto) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.postRegisEvent(dto, "api/registrations/");
      if (json != null) {
        return "Đăng ký thành công";
      }
    }catch(e){
        return "Người dùng đã đăng ký sự kiện";
    }
  }

  Future cancelRegisEvents(String idStudents) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.put(idStudents, "api/registrations/");
      if (json != null) {
        return "Hủy ký tham gia sự kiện thành công";
      }
    }catch(e){
      return "Lỗi đăng kí hủy tham gia";
    }
  }
}