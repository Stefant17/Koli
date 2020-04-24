import 'package:flutter/material.dart';

class FadePageTransition extends PageRouteBuilder{
  final Widget widget;
  double offset;

  FadePageTransition({ this.widget, this.offset }) : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return widget;
      },

      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return new FadeTransition(
          child: child,
          opacity: animation,
        );
      }
  );
}