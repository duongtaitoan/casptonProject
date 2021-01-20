import 'package:designui/src/API/api_helper.dart';
import 'package:designui/src/Model/feedbackDTO.dart';

class FeedBackDAO{
  // submit question of user
  Future postFeedback(eventId,studentId,now,valueBody) async {
    try{
      ApiHelper _api = new ApiHelper();
      dynamic _tmpJson = await _api.postFeedBack(eventId,studentId,now,valueBody, "api/feedback");
      // if(_tmpJson["errorCode"] == 0){
      //   return "You have not checked in event and cannot give feedback for this event.";
      // }
      return "";
    }catch(e){
      return "";
    }
  }

  //get list ask question in BQT
  Future<List<FeedbackDTO>> getListQuestion() async {
    try{
      ApiHelper _api = new ApiHelper();
      dynamic _tmpJson = await _api.getIdEvent("api/feedback/questions");
      var value = _tmpJson as List;
      return value.map((e) => FeedbackDTO.fromJson(e)).toList();
    }catch(e){
    }
  }
}