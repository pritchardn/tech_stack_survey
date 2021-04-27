import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyResponse{
  List<String> questions;
  List<String> answers;
  String respondantName;
  Timestamp time;

  SurveyResponse ({this.respondantName = "Dummy"}){
    questions = [];
    answers = [];
    time = new Timestamp.now();
  }

  void addResponse(String question, String answer){
    this.questions.add(question);
    this.answers.add(answer);
  }

  void rename(String name){
    this.respondantName = name;
  }

  SurveyResponse.fromJson(Map<String, dynamic> json)
      : respondantName = json['name'],
        questions = json['questions'],
        time = Timestamp.fromDate(DateTime.parse(json['time'])),
        answers = json['answers'];

  Map<String, dynamic> toJson() => {
    'name': respondantName,
    'questions': questions,
    'answers': answers,
    'time': time.toDate().toString()
  };

  String toString(){
    return questions.length.toString() + " " + answers.length.toString();
  }
}