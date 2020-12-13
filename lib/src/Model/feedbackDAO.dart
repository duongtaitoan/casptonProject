import 'package:designui/src/API/api_helper.dart';

class FeedBackDAO{
  Future postFeedback(String listQvsA,int idEvent) async {
    try{
    ApiHelper _api = new ApiHelper();
    dynamic _tmpJson = await _api.postFeedBack(listQvsA, idEvent, "api/feedbacks");
    return _tmpJson;
  }catch(e){
    }
  }

  // get status checkIn of user
  Future<bool> checkFeedBack(int userId, int idEvents) async {
    try {
      ApiHelper _api = new ApiHelper();
      var json = await _api.get("api/registrations?EventId=${idEvents}&UserId=${userId}");
      if (json["message"].toString().compareTo("Not found") != 0) {
        return true;
      }else{
        return false;
      }
    }catch(e){
      return true;
    }
  }
}