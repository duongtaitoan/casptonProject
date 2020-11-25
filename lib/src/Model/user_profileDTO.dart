class UserProfileDTO{
  String phone;
  String major;
  String studentCode;
  String fullname;
  String email;

  UserProfileDTO({this.phone, this.major, this.studentCode,this.fullname,this.email});

  factory UserProfileDTO.fromJson(Map < String, dynamic> json) =>
    UserProfileDTO(
      phone :json["phone"],
      major: json["major"],
      studentCode: json["studentCode"],
      fullname: json["fullname"],
      email: json["email"]
  );
}