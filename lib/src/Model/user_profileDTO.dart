class UserProfileDTO{
  int id;
  String fullName;
  String email;
  String phone;
  String studentCode;
  String major;
  String semester;

  UserProfileDTO({this.id,this.phone, this.major, this.studentCode,this.fullName,this.email,this.semester});

  factory UserProfileDTO.fromJson(Map < String, dynamic> json) =>
    UserProfileDTO(
      id:json["id"],
      phone :json["phoneNumber"],
      major: json["major"],
      studentCode: json["studentId"],
      fullName: json["preferredName"],
      email: json["email"],
      semester: json["semester"]
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['preferredName'] = this.fullName;
    data['phoneNumber'] = this.phone;
    data['studentId'] = this.studentCode;
    data['major'] = this.major;
    data['email'] = this.email;
    data['semester'] = this.semester;
    return data;
  }
}