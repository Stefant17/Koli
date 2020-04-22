import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FunFacts extends StatefulWidget {
  @override
  _FunFactsState createState() => _FunFactsState();
}

class _FunFactsState extends State<FunFacts> {
  Timer fadeOutTimer;

  Random random = new Random();

  double currentOpacity = 1.0;

  List<String> facts = [
    'Ræktaðir skógar á Íslandi binda nú um 330.000 tonn af CO2',
    'Á hverju ári losum við rúmlega 36 milljarði tonna af CO2 á heimsvísu',
    'Akstur metanbíla er kolefnishlutlaus',
    'Venjuleg farþegaþota sem flogið er í 6 klst losar \n66-76 tonn af CO2',
  ];
  int currentFactIndex;

  bool lowerOpacity = true;
  
  @override
  void initState() {
    super.initState();
    fadeOutTimer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      setState(() {
        currentOpacity = 0.0;
      });

      Future.delayed(const Duration(seconds: 4), () {
        nextFact();
      });
    });

    currentFactIndex = random.nextInt(facts.length);
  }

  @override
  void dispose() {
    fadeOutTimer.cancel();
    super.dispose();
  }

  void nextFact() {
    int newIndex = random.nextInt(facts.length);
    if(newIndex == currentFactIndex) {
      while(newIndex == currentFactIndex) {
        newIndex = random.nextInt(facts.length);
      }
    }

    setState(() {
      currentFactIndex = newIndex;
      currentOpacity = 1.0;
      lowerOpacity = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: currentOpacity,
      duration: Duration(seconds: 2),
      child: Text(
        facts[currentFactIndex],
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 15,
        )
      ),
    );
    /*
    return RotateAnimatedTextKit(
      duration: Duration(milliseconds: 2000),
      //pause: Duration(milliseconds: 4000),
      text: facts,
      textStyle: TextStyle(
        fontSize: 15,
      ),
      textAlign: TextAlign.start,
    );*/
  }
}
