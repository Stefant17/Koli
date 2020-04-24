import 'package:flutter/material.dart';

class AnimatedCounter extends StatefulWidget {
  final co2;
  AnimatedCounter({ this.co2 });

  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController _controller;
  String i;

  @protected
  @mustCallSuper
  void initState() {
    super.initState();

    double a = this.widget.co2.toDouble();
    int time = 2;
    var rounded = ((a~/100).round() * 100);

    if(a > 100) {
      time = (a~/rounded).toInt() + 1;
    }

    if(a > 1000) {
      time += 3;
    }

    _controller = AnimationController(duration: Duration(seconds: time), vsync: this);
    animation = Tween<double>(begin: 0, end: a).animate(_controller)
      ..addListener((){
        setState((){
          // The state that has changed here is the animation objects value
          i = animation.value.toStringAsFixed(0);
        });
      });
    _controller.forward();
    //_controller.dispose();
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$i kg',
      style: TextStyle(
        fontSize: 25,
        //color: Colors.blue
        color: Color(0xFFFAF9F9)
      ),
    );
  }
}