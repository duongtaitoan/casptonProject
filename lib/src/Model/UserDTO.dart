class UserDTO{
  int id;
  int eventId;
  int status;
  int studentId;

  UserDTO({this.id, this.eventId, this.status, this.studentId});

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
    id: json["id"],
    eventId: json["eventId"],
    status: json["status"],
    studentId: json["studentId"],
  );
}
