class RegisterEventsDTO{
  int eventId;

  RegisterEventsDTO({this.eventId});

  factory RegisterEventsDTO.fromJson(Map<String, dynamic> json) => RegisterEventsDTO(
    eventId: json["eventId"],
  );

}