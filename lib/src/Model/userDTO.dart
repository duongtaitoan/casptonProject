class UserDTO{
  int id;
  int eventId;
  String eventTitle;
  String startDate;
  String status;
  String statusEvent;
  String thumbnailPicture;

  UserDTO({this.id, this.eventId, this.eventTitle,this.startDate,this.status,this.thumbnailPicture,this.statusEvent});

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
    id: json["id"],
    eventId: json["eventId"],
    eventTitle: json["eventTitle"],
    startDate: json["startDate"],
    statusEvent: json["statusEvent"],
    status: json["status"],
    thumbnailPicture: json["thumbnailPicture"],
  );
}
