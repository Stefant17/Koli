import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final bottomBarIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Stillingar'),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Text('Aðgangur'),
          Text('Tilkynningar'),
          Text('Kort'),
          Text('Um Okkur')
        ],
      ),

      bottomNavigationBar: BottomBar(currentTab: bottomBarIndex),
      floatingActionButton: HomeFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}
