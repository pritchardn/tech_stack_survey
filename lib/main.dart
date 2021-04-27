import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Static.dart';
import 'constants.dart';
import 'QuestionElements.dart';
import 'SurveyResponse.dart';
import 'MaterialColorMaker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: generateMaterialColor(BRAND_PURPLE), brightness: Brightness.dark),
    home: SurveyStepper(),
  ));
}

void postResponse(CollectionReference repository, SurveyResponse response) async {
  await repository.add(response.toJson());
}

class SurveyStepper extends StatefulWidget {
  @override
  _SurveyStepperState createState() => _SurveyStepperState();
}

class _SurveyStepperState extends State<SurveyStepper> {
  int pageNumber = 0;
  SurveyResponse response = new SurveyResponse();
  final CollectionReference repository = FirebaseFirestore.instance.collection("responses");
  @override
  Widget build(BuildContext context) {
    Widget page;
    if(pageNumber == QUESTIONS.length){
      page = Question(
        key: Key((-1).toString()),
        onOptionSelected: (answer) => setState((){
          if(answer == "Yes"){
            print("Submitting");
            postResponse(repository, response);
          }
        }),
        question: "Submit?",
        answers: ["Yes", "No"],
        number: 0,
      );
      pageNumber = -1;
    } else if (pageNumber >= 0) {
      page = Question(
        key: Key(pageNumber.toString()),
        onOptionSelected: (answer) => setState((){
          this.response.addResponse(QUESTIONS[pageNumber], answer);
          ++pageNumber;
        }
        ),
        question: QUESTIONS[pageNumber],
        answers: ANSWERS[pageNumber],
        number: pageNumber+1,
      );
    } else {
      page = FinalPage();
    }
    return Scaffold(
     body: Container(
       width: double.infinity,
       height: double.infinity,
       decoration: backgroundDecoration,
       child: SafeArea(
         child: Stack(
           children: <Widget>[
             Line(),
             Terminal(),
             Positioned.fill(
               left: ICON_SIZE / 2 + LINE_WIDTH / 2 + DOT_SIZE / 2,
               child: AnimatedSwitcher(
                 child: page,
                 duration: Duration(milliseconds: 250),
               ),
             ),
           ],
         )
       )
     )
    );
  }
}

class FinalPage extends StatefulWidget {
  FinalPage();

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Spacer(),
        Text(
          "Thanks for responding",
          style: new TextStyle(
            fontSize: FONT_SIZE_QUESTION,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        SizedBox(height: 0.1 * query.height)
      ],
    );
  }
}
