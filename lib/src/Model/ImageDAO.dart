import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/imageDTO.dart';

class ImageDAO{

  Future imageTracking(ImageDTO dto) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.uploadImage(dto, "api/trackings");
      if (json >= 200 || json <= 204) {
        return 1;
      }
    }catch(e){
      return 0;
    }
  }
}