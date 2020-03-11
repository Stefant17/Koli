import 'package:flutter/cupertino.dart';
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
    return Stack(
      //mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.grey[800],
          child: Row(
            children: <Widget> [
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                  decoration: BoxDecoration(
                    border: selectedIndex == 0 ? Border(
                      top: BorderSide(
                        width: 5,
                        color: Colors.blue,
                      ),
                    ) : null,
                  ),
                  child: Container(
                    transform: Matrix4.translationValues(0.0, -15.0, 0.0),
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
                ),
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                  decoration: BoxDecoration(
                    border: selectedIndex == 1 ? Border(
                      top: BorderSide(
                        width: 5,
                        color: Colors.blue,
                      ),
                    ) : null,
                  ),
                  child: Container(
                    transform: Matrix4.translationValues(0.0, -15.0, 0.0),
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
                ),
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                  decoration: BoxDecoration(
                    border: selectedIndex == 2 ? Border(
                      top: BorderSide(
                        width: 5,
                        color: Colors.blue,
                      ),
                    ) : null,
                  ),
                  child: Container(
                    transform: Matrix4.translationValues(0.0, -15.0, 0.0),
                    child: InkWell(
                      child: Icon(
                        FontAwesomeIcons.userFriends,
                        color: selectedIndex == 2 ? highLightColor : Colors.white,
                      ),
                      onTap: () {
                        setState(() {
                          if(selectedIndex != 2) {
                            selectedIndex = 2;
                          } else {
                            selectedIndex = -1;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
      ],
    );
  }
}