import 'package:flutter/material.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Prófíll'),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('meKoli'),
            onPressed: () {
              Navigator.pushNamed(context, '/meKoli stillingar');
            },
          ),

          RaisedButton(
            child: Text('Mataræði'),
            onPressed: () {
              Navigator.pushNamed(context, '/Mataræði stillingar');
            },
          )
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
