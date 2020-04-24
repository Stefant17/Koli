import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/notification.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final bottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: appBar(context, 'Tilkynningar'),
      body: Column(
        children: <Widget>[
          StreamBuilder<List<UserNotification>> (
            stream: DatabaseService(uid: user.uid).friendRequests,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<UserNotification> friendRequests = snapshot.data;

                return Expanded(
                  child: Container(
                    child: ListView(
                      children: friendRequests.map((req) {
                        return Row(
                          children: <Widget>[
                            Text('Vinarbeiðni frá ${req.from}'),
                            RaisedButton(
                              child: Text('Staðfesta'),
                              elevation: 0,
                              onPressed: () {
                                DatabaseService(uid: user.uid).acceptFriendRequest(req.fromID, req.notificationID);
                              },
                            ),

                            RaisedButton(
                              child: Text('Hafna'),
                              elevation: 0,
                              onPressed: () {
                                DatabaseService(uid: user.uid).declineFriendRequest(req.fromID, req.notificationID);
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    )
                  ),
                );
              } else {
                return Container();
              }
            }
          ),

          StreamBuilder<List<UserNotification>>(
            stream: DatabaseService(uid: user.uid).notifications,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                List<UserNotification> notifications = snapshot.data;

                return Column(
                  children: <Widget>[

                  ],
                );
              } else {
                return Container();
              }
            }
          )
        ],
      ),

      bottomNavigationBar: BottomBar(currentTab: bottomBarIndex),
      floatingActionButton: Constants().homeFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}
