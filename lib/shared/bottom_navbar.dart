import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/screens/friends/friend_wrapper.dart';
import 'package:koli/screens/settings/settings.dart';
import 'package:koli/shared/fade_page_transition.dart';
import 'package:koli/views/messagelist_view.dart';
import 'package:koli/views/notificationlist_view.dart';

class BottomBar extends StatefulWidget {
  final currentTab;
  BottomBar({ this.currentTab });

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    int currentTab = widget.currentTab;
    if(currentTab == null) {
      currentTab = -1;
    }

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: Colors.black,
      child: Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                minWidth: 40,
                child: Icon(
                  Icons.notifications,
                  color: currentTab == 0 ? Colors.blueAccent : Colors.white,
                  size: 30,
                ),

                onPressed: () {
                  if(currentTab != 0) {
                    setState(() {
                      currentTab = 0;
                    });

                    Navigator.push(
                        context,
                        FadePageTransition(
                          widget: NotificationList(),
                        )
                    );
                  } else {
                    setState(() {
                      currentTab = -1;
                    });
                  }
                },
              ),
            ),

            Expanded(
              child: MaterialButton(
                minWidth: 40,
                child: Icon(
                  FontAwesomeIcons.commentDots,
                  color: currentTab == 1 ? Colors.blueAccent : Colors.white,
                  size: 30,
                ),

                onPressed: () {
                  if(currentTab != 1) {
                    setState(() {
                      currentTab = 1;
                    });

                    Navigator.push(
                      context,
                      FadePageTransition(
                        widget: MessageList(),
                      )
                    );
                  } else {
                    setState(() {
                      currentTab = -1;
                    });
                  }
                },
              ),
            ),

            Expanded(
              child: MaterialButton(
                //minWidth: 40,
                child: Icon(
                  Icons.group,
                  color: currentTab == 2 ? Colors.blueAccent : Colors.white,
                  size: 30,
                ),

                onPressed: () {
                  if(currentTab != 2) {
                    setState(() {
                      currentTab = 2;
                    });

                    Navigator.push(
                        context,
                        FadePageTransition(
                          widget: FriendWrapper(),
                        )
                    );

                  } else {
                    setState(() {
                      currentTab = -1;
                    });
                  }
                },
              ),
            ),

            Expanded(
              child: MaterialButton(
                minWidth: 50,
                child: Icon(
                  Icons.settings,
                  color: currentTab == 3 ? Colors.blueAccent : Colors.white,
                  size: 30,
                ),

                onPressed: () {
                  if(currentTab != 3) {
                    setState(() {
                      currentTab = 3;
                    });

                    Navigator.push(
                      context,
                      FadePageTransition(
                        widget: Settings(),
                      )
                    );
                  } else {
                    setState(() {
                      currentTab = -1;
                    });
                  }
                },
              ),
            )
          ],
        )
      )
    );
  }
}