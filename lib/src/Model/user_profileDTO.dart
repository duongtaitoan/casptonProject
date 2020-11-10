class UserProfileDTO{
  int phone;
  String major;
  String studentCode;

  UserProfileDTO({this.phone, this.major, this.studentCode});

  factory UserProfileDTO.fromJson(Map < String, dynamic> json) =>
    UserProfileDTO(
      phone :json["phone"],
      major: json["major"],
      studentCode: json["studentCode"]
  );
}