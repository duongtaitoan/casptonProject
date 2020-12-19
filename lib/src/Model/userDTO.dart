class UserDTO{
  int id;
  int eventId;
  String eventTitle;
  String startDate;
  String status;
  String EventStatus;
  String thumbnailPicture;

  UserDTO({this.id, this.eventId, this.eventTitle,this.startDate,this.status,this.thumbnailPicture,this.EventStatus});

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
    id: json["id"],
    eventId: json["eventId"],
    eventTitle: json["eventTitle"],
    startDate: json["startDate"],
    EventStatus: json["EventStatus"],
    status: json["status"],
    thumbnailPicture: json["thumbnailPicture"],
  );
}
