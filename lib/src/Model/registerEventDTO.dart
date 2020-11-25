class RegisterEventsDTO{
  int eventId;
  int semester;
  String studentCode;


  RegisterEventsDTO({this.eventId, this.semester, this.studentCode});

  factory RegisterEventsDTO.fromJson(Map<String, dynamic> json) => RegisterEventsDTO(
    eventId: json["eventId"],
    semester: json["semester"],
    studentCode: json["studentCode"],
  );

}