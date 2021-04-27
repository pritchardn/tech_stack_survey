import 'dart:html';

import 'package:flutter/material.dart';
import 'constants.dart';
import 'OptionItem.dart';
import 'Dot.dart';

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

class Question extends StatefulWidget {

  final int number;
  final String question;
  final List<String> answers;
  final FunctionStringCallback onOptionSelected;

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
  Animation _animation;

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
    _animation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut
    );
    onInit();
  }

  Future<void> animateDot(Offset startOffset) async {
    Size query = MediaQuery.of(context).size;
    OverlayEntry entry = OverlayEntry(
      builder: (context) {
        double minTop = TOP_INSET * query.height + ICON_SIZE/2;
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Positioned(
              left: LEFT_INSET * query.width + ICON_SIZE/2 - DOT_SIZE/2 + LINE_WIDTH/2,
              top:  minTop + ((startOffset.dy - minTop) + FONT_SIZE_QUESTION) * (1 - _animation.value) ,
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
        animateDot(offset).then((_) => widget.onOptionSelected(widget.answers[selectedOptionKeyIndex-2]));
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