import 'package:flutter/material.dart';
import 'static.dart';
import 'constants.dart';
import 'QuestionElements.dart';
import 'SurveyResponse.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.amber, brightness: Brightness.dark),
    home: SurveyStepper(),
  ));
}

class SurveyStepper extends StatefulWidget {
  @override
  _SurveyStepperState createState() => _SurveyStepperState();
}

class _SurveyStepperState extends State<SurveyStepper> {
  int pageNumber = 0;

  @override
  Widget build(BuildContext context) {
    Widget page = Question(
      key: Key(pageNumber.toString()),
      onOptionSelected: () => setState(() => pageNumber = (++pageNumber % QUESTIONS.length)),
      question: QUESTIONS[pageNumber],
      answers: ANSWERS[pageNumber],
      number: pageNumber,
    );
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