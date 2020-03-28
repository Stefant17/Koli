import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/views/friendlist_view.dart';
import 'package:koli/views/messagelist_view.dart';
import 'package:koli/views/notificationlist_view.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = -1;
  Color highLightColor = Colors.blue;
  Color defaultColor = Colors.white;
  bool isBottomPanelUp = false;

  List panelList = [NotificationList(), MessageList(), FriendList()];

  void showBottomSheet(BuildContext context) {
    int index = selectedIndex;

    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context){
        return StatefulBuilder (
          builder: (BuildContext context, StateSetter sheetSetState) {
            void update(int newIndex) {
              sheetSetState(() => index = newIndex);
            }

            if(selectedIndex >= 0) {
              return Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: openBottomNav(update),
                  ),

                  Expanded(
                    child: Container(
                      child: panelList[index],
                    ),
                  ),
                ]
              );
            } else {
              return Text('');
            }
          }
        );
      }
    );
  }

  Column showFriendPanel() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomCenter,
          child: bottomNav(),
        ),

        Expanded(
          child: Container(
            child: FriendList(),
          ),
        ),
      ]
    );
  }

  Column showNotificationPanel() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomCenter,
          child: bottomNav(),
        ),

        Expanded(
          child: Container(
            child: NotificationList(),
          ),
        ),
      ]
    );
  }

  Column showMessagePanel() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomCenter,
          child: bottomNav(),
        ),

        Expanded(
          child: Container(
            child: MessageList(),
          ),
        ),
      ]
    );
  }

  void bottomModalControls(int index) {
    if(selectedIndex != index) {
      setState(() => selectedIndex = index);

      if(!isBottomPanelUp) {
        showBottomSheet(context);
        isBottomPanelUp = true;
      }
    } else {
      setState(() => selectedIndex = -1);

      if(isBottomPanelUp) {
        Navigator.pop(context);
        isBottomPanelUp = false;
      }
    }
  }

  void openBottomModalControls(int index, update) {
    if(selectedIndex != index) {
      setState(() => selectedIndex = index);
      update(index);

      if(!isBottomPanelUp) {
        showBottomSheet(context);
        isBottomPanelUp = true;
      }
    } else {
      setState(() => selectedIndex = -1);


      if(isBottomPanelUp) {
        Navigator.pop(context);
        isBottomPanelUp = false;
      }
    }
  }

  Container bottomNavButtons(int index, icon) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      decoration: BoxDecoration(
        border: selectedIndex == index ? Border(
          bottom: BorderSide(
            width: 5,
            color: Colors.blue,
          ),
        ) : null,
      ),
      child: Container(
        transform: Matrix4.translationValues(0.0, -15.0, 0.0),
        child: InkWell(
          child: Icon(
            icon,
            color: selectedIndex == index ? highLightColor : Colors.white,
          ),
          onTap: () {
            bottomModalControls(index);
          },
        ),
      ),
    );
  }

  Container openBottomNavButtons(int index, icon, update) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
      decoration: BoxDecoration(
        border: selectedIndex == index ? Border(
          bottom: BorderSide(
            width: 5,
            color: Colors.blue,
          ),
        ) : null,
      ),
      child: Container(
        transform: Matrix4.translationValues(0.0, -15.0, 0.0),
        child: InkWell(
          child: Icon(
            icon,
            color: selectedIndex == index ? highLightColor : Colors.white,
          ),
          onTap: () {
            openBottomModalControls(index, update);
          },
        ),
      ),
    );
  }

  Container openBottomNav(update) {
    return Container(
      height: 50,
      color: Colors.grey[800],
      child: Row(
          children: <Widget> [
            Expanded(
              child: openBottomNavButtons(0, FontAwesomeIcons.solidBell, update),
            ),

            Expanded(
              child: openBottomNavButtons(1, FontAwesomeIcons.solidCommentAlt, update),
            ),

            Expanded(
              child: openBottomNavButtons(2, FontAwesomeIcons.userFriends, update),
            ),
          ]
      ),
    );
  }

  Container bottomNav() {
    return Container(
      height: 50,
      color: Colors.grey[800],
      child: Row(
        children: <Widget> [
          Expanded(
            child: bottomNavButtons(0, FontAwesomeIcons.solidBell),
          ),

          Expanded(
            child: bottomNavButtons(1, FontAwesomeIcons.solidCommentAlt),
          ),

          Expanded(
            child: bottomNavButtons(2, FontAwesomeIcons.userFriends),
          ),
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      //mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        bottomNav(),
      ],
    );
  }
}