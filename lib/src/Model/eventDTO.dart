class EventsDTO{
  int id;
  String title;
  String description;
  int duration;
  String location;
  bool gpsTrackingRequired;
  String startedAt;
  int maximumParticipant;
  String note;
  String status;

  EventsDTO({
      this.id,
      this.title,
      this.description,
      this.duration,
      this.location,
      this.gpsTrackingRequired,
      this.startedAt,
      this.maximumParticipant,
      this.note,
      this.status}); // DateTime timeStop;



  factory EventsDTO.fromJson(Map<String, dynamic> json) => EventsDTO(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    duration: json["duration"],
    location: json["location"],
    gpsTrackingRequired: json["gpsTrackingRequired"],
    startedAt: json["startedAt"],
    maximumParticipant: json["maximumParticipant"],
    note: json["note"],
    status: json["status"],
  );

}