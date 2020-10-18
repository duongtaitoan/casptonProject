class EventsDTO{
  String title;
  String content;
  String img;
  DateTime timeStart;
  DateTime timeStop;

  EventsDTO({this.title, this.content, this.img, this.timeStart, this.timeStop});

  factory EventsDTO.fromJson(Map<String, dynamic> json) => EventsDTO(
    title: json[""],
    content: json[""],
    img: json[""],
    timeStart: json[""],
    timeStop: json[""],
  );

}