import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = -1;
  Color highLightColor = Colors.blue;
  Color defaultColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.grey[800],
      child: Row(
        children: <Widget> [
          Expanded(
            child: InkWell(
              child: Icon(
                FontAwesomeIcons.solidBell,
                color: selectedIndex == 0 ? highLightColor : Colors.white,
              ),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
            ),
          ),

          Expanded(
            child: InkWell(
              child: Icon(
                FontAwesomeIcons.solidCommentAlt,
                color: selectedIndex == 1 ? highLightColor : Colors.white,
              ),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
            ),
          ),

          Expanded(
            child: InkWell(
              child: Icon(
                FontAwesomeIcons.userFriends,
                color: selectedIndex == 2 ? highLightColor : Colors.white,
              ),
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
            ),
          ),
        ]
      ),
    );
  }
}