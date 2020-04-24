import 'package:flutter/material.dart';

class SlidePageTransition extends PageRouteBuilder{
  final Widget widget;
  double offset;

  SlidePageTransition({ this.widget, this.offset }) : super(
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return widget;
    },

    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      return new SlideTransition(
        position: new Tween<Offset> (
          begin: new Offset(offset, 0.0),
          end: Offset.zero
        ).animate(animation),
        child: child,
      );
    }
  );
}