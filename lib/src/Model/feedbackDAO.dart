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
}