class UserDTO{
  int id;
  int eventId;
  int studentId;
  String eventName;
  String eventEndTime;
  String status;
  String eventThumbnail;
  String eventLocation;

  UserDTO({this.id, this.eventId, this.eventName,this.eventEndTime,this.status,this.eventThumbnail,this.studentId,this.eventLocation});

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
    id: json["id"],
    eventId: json["eventId"],
    studentId: json["studentId"],
    eventName: json["eventName"],
    eventEndTime: json["eventEndTime"],
    status: json["status"],
    eventLocation: json["eventLocation"],
    eventThumbnail: json["eventThumbnail"],
  );
}
