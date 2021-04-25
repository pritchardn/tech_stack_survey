class SurveyResponse{
  List<String> questions;
  List<String> answers;
  String respondantName;

  SurveyResponse ({this.respondantName = "Dummy"}){
    questions = [];
    answers = [];
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
        answers = json['answers'];

  Map<String, dynamic> toJson() => {
    'name': respondantName,
    'questions': questions,
    'answers': answers
  };

  String toString(){
    return questions.length.toString() + " " + answers.length.toString();
  }
}