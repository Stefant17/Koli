import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        //title: Text('Koli'),
        //centerTitle: true,
        backgroundColor: Colors.grey[400],
        elevation: 0.0,

        // Dropdown list, user profile
        actions: <Widget>[
          Text('OVERVIEW NIGGAAAAAAAAAAAAAAAAAA'),
        ],
      ),
    );
  }
}
