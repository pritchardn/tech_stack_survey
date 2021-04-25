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