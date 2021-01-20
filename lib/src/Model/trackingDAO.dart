import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/TrackingDTO.dart';

class TrackingDAO {
  Future locationTracking(TrackingDTO dto) async {
    ApiHelper _api = new ApiHelper();
    Map<String, dynamic> json = await _api.postTracking(dto,"api/tracking");
    if(json != null){
        return 1;
    }
  }

  Future trackingFirst(last,long,address,checkinQr,idEvent) async {
    ApiHelper _api = new ApiHelper();
    dynamic json = await _api.postTrackingFirst(last,long,address,checkinQr,"api/events/${idEvent}/check-in");
    print('tracking json ${json}');
    if(json["errorCode"] == 403){
      return json["message"];
    }else if(json["errorCode"] == 500){
      return "Tracking error";
    }else{
      return json["message"];
    }
  }
}