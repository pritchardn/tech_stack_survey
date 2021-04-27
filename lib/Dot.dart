import 'package:flutter/material.dart';
import 'constants.dart';

class Dot extends StatelessWidget {
  final bool visible;
  final Color color;
  const Dot({Key key, this.visible = true, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DOT_SIZE,
      height: DOT_SIZE,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: visible ? color : Colors.transparent,
      ),
    );
  }
}