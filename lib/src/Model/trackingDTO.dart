class TrackingDTO{
  int eventId;
  double latitude;
  double longitude;

  TrackingDTO({ this.eventId, this.latitude, this.longitude});

  factory TrackingDTO.fromJson(Map<String, dynamic> json) => TrackingDTO(
    eventId: json["eventId"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "eventId": this.eventId,
    "latitude": this.latitude,
    "longitude": this.longitude,
  };

}