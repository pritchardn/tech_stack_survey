import 'package:flutter/material.dart';
import 'constants.dart';

class Line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Positioned(
      left: LEFT_INSET * query.width + (ICON_SIZE / 2),
      top: TOP_INSET * query.height + ICON_SIZE / 2,
      bottom: 0,
      width: LINE_WIDTH,
      child: Container(color: Colors.white.withOpacity(0.5)),
    );
  }
}

class Terminal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Positioned(
        left: LEFT_INSET * query.width + LINE_WIDTH / 2,
        top: TOP_INSET * query.height,
        child: Icon(
          Icons.circle,
          size: ICON_SIZE,
        )
    );
  }
}

const backgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: backgroundPalette,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

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
