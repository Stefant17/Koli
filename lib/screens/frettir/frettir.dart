import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koli/shared/appbar.dart';
import 'package:provider/provider.dart';
import 'package:koli/shared/bottom_navbar.dart';

class Frettir extends StatefulWidget {
  @override
  _FrettirState createState() => _FrettirState();
}


class _FrettirState extends State<Frettir> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: appBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'FRETTIR',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}


