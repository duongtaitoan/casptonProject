class EventsDTO{
  int id;
  String title;
  String content;
  int duration;
  String location;
  bool gpsTrackingRequired;
  bool approvalRequired;
  String startedAt;
  // int remainingSeats;
  String cancelUnavailableAt;
  int capacity;
  String note;
  String status;
  String picture;
  String thumbnailPicture;
  String host;

  EventsDTO({
      this.id,
      this.title,
      this.content,
      this.duration,
      this.location,
      this.gpsTrackingRequired,
      this.approvalRequired,
      this.startedAt,
      // this.remainingSeats,
      this.cancelUnavailableAt,
      this.capacity, this.note,
      this.status,this.thumbnailPicture,this.picture,this.host}); // DateTime timeStop;

  factory EventsDTO.fromJson(Map<String, dynamic> json) => EventsDTO(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    duration: json["duration"],
    location: json["location"],
    gpsTrackingRequired: json["gpsTrackingRequired"],
    approvalRequired: json["approvalRequired"],
    startedAt: json["startedAt"],
    // remainingSeats:json["remainingSeats"],
    cancelUnavailableAt:json["cancelUnavailableAt"],
    capacity: json["capacity"],
    note: json["note"],
    status: json["status"],
    thumbnailPicture: json["thumbnailPicture"],
    picture: json["picture"],
    host: json["host"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['duration'] = this.duration;
    data['location'] = this.location;
    data['startedAt'] = this.startedAt;
    data['cancelUnavailableAt'] = this.cancelUnavailableAt;
    data['gpsTrackingRequired'] = this.gpsTrackingRequired;
    data['approvalRequired'] = this.approvalRequired;
    data['capacity'] = this.capacity;
    data['note'] = this.note;
    data['status'] = this.status;
    data['picture'] = this.picture;
    data['thumbnailPicture'] = this.thumbnailPicture;
    data['host'] = this.host;
    return data;
  }

}