import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/TrackingDTO.dart';

class TrackingDAO {
  Future locationTracking(TrackingDTO dto) async {
    ApiHelper _api = new ApiHelper();
    Map<String, dynamic> json = await _api.postTracking(dto,"api/trackings");
    if(json != null){
        return 1;
    }
  }
}