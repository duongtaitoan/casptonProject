class RegisterEventsDTO{
  int eventId;
  int semester;
  int studentId;

  RegisterEventsDTO({this.eventId, this.semester, this.studentId});

  factory RegisterEventsDTO.fromJson(Map<String, dynamic> json) => RegisterEventsDTO(
    eventId: json["eventId"],
    semester: json["semester"],
    studentId: json["studentId"],
  );

}