class TrackingDTO{
  int eventId;
  int studentId;
  double latitude;
  double longitude;
  String trackedAt;
  String address;

  TrackingDTO({ this.latitude, this.longitude,this.studentId,this.eventId,this.address,this.trackedAt});

  factory TrackingDTO.fromJson(Map<String, dynamic> json) => TrackingDTO(
    eventId: json["eventId"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    studentId: json["studentId"],
    trackedAt: json["trackedAt"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "eventId": this.eventId,
    "latitude": this.latitude,
    "longitude": this.longitude,
    "address": this.address,
    "trackedAt": this.trackedAt,
    "studentId": this.studentId,
  };

}