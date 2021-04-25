import 'package:flutter/material.dart';
import 'static.dart';
import 'constants.dart';

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
               left: 32.0 + 8,  // TODO: Remove hard-coding
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

class Question extends StatefulWidget {

  final int number;
  final String question;
  final List<String> answers;
  final VoidCallback onOptionSelected;

  const Question({
    Key key,
    @required this.onOptionSelected,
    @required this.number,
    @required this.question,
    @required this.answers})
    : super(key: key);

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question>
    with SingleTickerProviderStateMixin {
  List<GlobalKey<_ItemFaderState>> keys;
  int selectedOptionKeyIndex;
  AnimationController _animationController;

  @override
  void initState(){
    super.initState();
    keys = List.generate(
      2 + widget.answers.length,
        (_) => GlobalKey<_ItemFaderState>(),
    );
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: DOT_MOVE_DURATION),
    );
    onInit();
  }

  Future<void> animateDot(Offset startOffset) async {
    Size query = MediaQuery.of(context).size;
    OverlayEntry entry = OverlayEntry(
      builder: (context) {
        double minTop = TOP_INSET * query.height + ICON_SIZE/2;
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Positioned(
              left: LEFT_INSET * query.width + ICON_SIZE/2 - LINE_WIDTH,
              top: minTop +
                  (startOffset.dy - minTop) * (1 - _animationController.value),
              child: child,
            );
          },
          child: Dot(),
        );
      },
    );
    Overlay.of(context).insert(entry);
    await _animationController.forward(from: 0);
    entry.remove();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: TOP_INSET * query.height),
        ItemFader(
            key: keys[0],
            child: StepNumber(number: widget.number)
        ),
        ItemFader(
            key: keys[1],
            child: StepQuestion(question: widget.question)
        ),
        Spacer(),
        ...widget.answers.map((String answer){
          int answerIndex = widget.answers.indexOf(answer);
          int keyIndex = answerIndex + 2;
          return ItemFader(
            key: keys[keyIndex],
            child: OptionItem(
              name: answer,
              onTap: (offset) => onTap(keyIndex, offset),
              showDot: selectedOptionKeyIndex != keyIndex,
            ),
          );
        }),
        SizedBox(height: 0.1 * query.height)
      ],
    );
  }

  void onTap(int keyIndex, Offset offset) async {
    for (GlobalKey<_ItemFaderState> key in keys){
      await Future.delayed(Duration(milliseconds: 40));
      key.currentState.hide();
      if(keys.indexOf(key) == keyIndex){
        setState(() => selectedOptionKeyIndex = keyIndex);
        animateDot(offset).then((_) => widget.onOptionSelected());
      }
    }
  }


  void onInit() async {
    for (GlobalKey<_ItemFaderState> key in keys){
      await Future.delayed(Duration(milliseconds: 40));
      key.currentState.show();
    }
  }

}

class StepNumber extends StatelessWidget {
  final int number;

  const StepNumber({Key key, @required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: LEFT_INSET * query.width + ICON_SIZE, right: 16),
      child: Text(
        '0$number',
        style: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}

class StepQuestion extends StatelessWidget {
  final String question;

  const StepQuestion({Key key, @required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: LEFT_INSET * query.width + ICON_SIZE, right: 16),
      child: Text(
        question,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}


class OptionItem extends StatefulWidget {
  final String name;
  final void Function(Offset dotOffset) onTap; //Offset dotOffset) onTap;
  final bool showDot;

  const OptionItem(
  {Key key, @required this.name, @required this.onTap, this.showDot = true})
  : super(key: key);

  @override
  _OptionItemState createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        RenderBox object = context.findRenderObject();
        Offset globalPosition = object.localToGlobal(Offset.zero);
        widget.onTap(globalPosition);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Padding(
          padding: EdgeInsets.only(left: LEFT_INSET * query.width - DOT_SIZE),
          child: Row(
            children: <Widget>[
              //SizedBox(width: 26),
              Dot(visible: widget.showDot),
              SizedBox(width: 26),
              Expanded(
                child: Text(
                  widget.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}


class ItemFader extends StatefulWidget {
  final Widget child;
  const ItemFader({Key key, @required this.child}) : super(key: key);

  @override
  _ItemFaderState createState() => _ItemFaderState();
}

class _ItemFaderState extends State<ItemFader>
    with SingleTickerProviderStateMixin {
  // 0 center, 1 below, -1 above (TL coords)
  int position = 1;
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: TEXT_FADE_DURATION),
    );
    _animation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child){
        return Transform.translate(
          offset: Offset(0, TEXT_TRAVEL_DISTANCE * position * (1 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }

  void show(){
    setState(() => position = 1);
    _animationController.forward();
  }

  void hide(){
    setState(() => position = -1);
    _animationController.reverse();
  }

  @override
  void dispose(){
    _animationController.dispose();
    super.dispose();
  }
}


class Dot extends StatelessWidget {
  final bool visible;

  const Dot({Key key, this.visible = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DOT_SIZE,
      height: DOT_SIZE,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: visible ? Colors.white : Colors.transparent,
      ),
    );
  }
}


