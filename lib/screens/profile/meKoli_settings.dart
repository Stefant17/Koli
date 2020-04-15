import 'package:flutter/material.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';

class MeKoliSettings extends StatefulWidget {
  @override
  _MeKoliSettingsState createState() => _MeKoliSettingsState();
}

class _MeKoliSettingsState extends State<MeKoliSettings> {
  @override
  Widget build(BuildContext context) {
    print('yo');

    return Scaffold(
      appBar: appBar(context, ''),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Image.asset(
                  'assets/images/meKoli/meKoli_face1.PNG',
                  width: 250,
                  height: 300,
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(50, 50, 0, 0),
                  child: Image.asset(
                    'assets/images/meKoli/meKoli_eyes11.PNG',
                    width: 150,
                    height: 150,
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(55, 120, 0, 0),
                  child: Image.asset(
                    'assets/images/meKoli/meKoli_mouth7.PNG',
                    width: 150,
                    height: 150,
                  ),
                ),
              ],
            ),
          )
        ],  
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
