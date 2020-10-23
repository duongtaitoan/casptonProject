import 'package:designui/src/Model/TrackingDTO.dart';
import 'package:designui/src/Model/trackingDAO.dart';

Future getLocation(TrackingDTO dto) async {
   try{
      TrackingDAO dao = new TrackingDAO();
      int tracking = await dao.locationTracking(dto);
      return tracking;
   } catch(e){
     print("Error: " + e.toString());
    throw(e);
  }
}