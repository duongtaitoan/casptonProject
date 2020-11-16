class EventsDTO{
  int id;
  String title;
  String description;
  int duration;
  String location;
  bool gpsTrackingRequired;
  String startedAt;
  int Capacity;
  String note;
  String status;
  String picture;
  String thumbnailPicture;

  EventsDTO({
      this.id,
      this.title,
      this.description,
      this.duration,
      this.location,
      this.gpsTrackingRequired,
      this.startedAt,
      this.Capacity,
      this.note,
      this.status,this.thumbnailPicture,this.picture}); // DateTime timeStop;

  factory EventsDTO.fromJson(Map<String, dynamic> json) => EventsDTO(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    duration: json["duration"],
    location: json["location"],
    gpsTrackingRequired: json["gpsTrackingRequired"],
    startedAt: json["startedAt"],
    Capacity: json["Capacity"],
    note: json["note"],
    status: json["status"],
    thumbnailPicture: json["thumbnailPicture"],
    picture: json["picture"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['location'] = this.location;
    data['startedAt'] = this.startedAt;
    data['gpsTrackingRequired'] = this.gpsTrackingRequired;
    data['Capacity'] = this.Capacity;
    data['note'] = this.note;
    data['status'] = this.status;
    data['picture'] = this.picture;
    data['thumbnailPicture'] = this.thumbnailPicture;
    return data;
  }

}