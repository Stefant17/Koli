import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FunFacts extends StatefulWidget {
  @override
  _FunFactsState createState() => _FunFactsState();
}

class _FunFactsState extends State<FunFacts> {
  List<String> facts = [
    'Ræktaðir skógar á Íslandi binda nú um 330.000 tonn af CO2',
    'Á hverju ári losum við rúmlega 36 milljarði tonna af CO2 á heimsvísu',
    'Akstur metanbíla er kolefnishlutlaus',
    'Venjuleg farþegaþota sem flogið er í 6 klst. losar 66-76 tonn af CO2',
  ];

  @override
  Widget build(BuildContext context) {
    return RotateAnimatedTextKit(
      duration: Duration(milliseconds: 2000),
      //pause: Duration(milliseconds: 4000),
      text: facts,
      textStyle: TextStyle(
        fontSize: 15,
      ),
      textAlign: TextAlign.start,
    );
  }
}
