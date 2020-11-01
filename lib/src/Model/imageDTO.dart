import 'dart:io';

class ImageDTO{
  int eventId;
  double latitude;
  double longitude;
  File file;


  ImageDTO({this.eventId,this.latitude,this.longitude, this.file});

  factory ImageDTO.fromJson(Map<String, dynamic> json) => ImageDTO(
    eventId: json["eventId"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "eventId": this.eventId,
    "latitude": this.latitude,
    "longitude": this.longitude,
    "file" : this.file,
  };
}