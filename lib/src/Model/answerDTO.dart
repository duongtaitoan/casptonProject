
class InfoAnswer {
  int eventId;
  // int studentId;
  // String recordedAt;
  List<AnswerDTO> answers;

  InfoAnswer({this.eventId,
    // this.studentId,
    this.answers,
    // this.recordedAt
  });

  Map<String, dynamic> toJson() => {
    "eventId": eventId,
    // "studentId": studentId,
    // "recordedAt": recordedAt,
    "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
  };

  factory InfoAnswer.fromJson(Map<String, dynamic> json) {
    return InfoAnswer(
        eventId: json['eventId'],
        // studentId: json['studentId'],
        // recordedAt: json['recordedAt'],
        answers: List<AnswerDTO>.from(json['answers'].map((item) => AnswerDTO.fromJson(json)))
    );
  }
}

class AnswerDTO{
  int questionId;
  String answer;
  int rating;

  AnswerDTO({this.questionId, this.answer, this.rating});

  factory AnswerDTO.fromJson(Map<String, dynamic> json) => AnswerDTO(
    questionId: json["questionId"],
    answer: json["answer"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "answer": answer,
    "rating": rating,
  };
}
