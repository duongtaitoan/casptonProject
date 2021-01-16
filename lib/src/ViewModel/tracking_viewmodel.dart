import 'package:designui/src/Model/imageDAO.dart';
import 'package:designui/src/Model/TrackingDTO.dart';
import 'package:designui/src/Model/imageDTO.dart';
import 'package:designui/src/Model/trackingDAO.dart';

Future sendLocation(TrackingDTO dto) async {
   try{
      TrackingDAO dao = new TrackingDAO();
      var tracking = await dao.locationTracking(dto);
      return tracking;
   } catch(e){
  }
}

Future sendLocationFirst(last,long,address,checkinQR,idEvent) async {
  try{
    TrackingDAO dao = new TrackingDAO();
    var tracking = await dao.trackingFirst(last,long,address,checkinQR,idEvent);
    return tracking;
  } catch(e){
  }
}

// Future<String> checkinEvents(ImageDTO dto) async {
//   try{
//     ImageDAO dao = new ImageDAO();
//     var value = await dao.imageTracking(dto);
//     if(value == 1) {
//       return "Check in successful";
//     }
//     return "Check in event failed";
//   } catch(e){
//   }
// }

