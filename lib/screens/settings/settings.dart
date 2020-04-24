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
      body: Text('Stillingar'),

      bottomNavigationBar: BottomBar(currentTab: bottomBarIndex),
      floatingActionButton: Constants().homeFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}
