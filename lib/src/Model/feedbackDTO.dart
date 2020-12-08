class FeedbackDTO{
  String question;
  String answer;

  FeedbackDTO({this.question, this.answer});

  factory FeedbackDTO.fromJson(Map<String,dynamic> json)=> FeedbackDTO(
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
    return data;
  }
}