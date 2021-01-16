class FeedbackDTO{
  int id;
  String question;
  String type;

  FeedbackDTO({this.id,this.question, this.type});

  factory FeedbackDTO.fromJson(Map<String,dynamic> json)=> FeedbackDTO(
    id: json["id"],
    question: json["question"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['type'] = this.type;
    return data;
  }
}