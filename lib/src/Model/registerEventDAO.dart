import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/registerEventDTO.dart';

class RegisterEventDAO{
  Future<String> registerEvents(RegisterEventsDTO dto) async {
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
}