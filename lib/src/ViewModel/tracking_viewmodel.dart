import 'package:designui/src/Model/ImageDAO.dart';
import 'package:designui/src/Model/TrackingDTO.dart';
import 'package:designui/src/Model/imageDTO.dart';
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

Future<String> checkinEvents(ImageDTO dto) async {
  try{
    ImageDAO dao = new ImageDAO();
    await dao.imageTracking(dto);
    return "Checkin thành công";
  } catch(e){
      return "Checkin bị lỗi!!";
  }
}

