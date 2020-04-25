import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/user.dart';
import 'package:koli/screens/friends/find_friends.dart';
import 'package:koli/screens/friends/friendlist_view.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/shared/friendlist_appbar.dart';
import 'package:provider/provider.dart';

class FriendWrapper extends StatefulWidget {
  @override
  _FriendWrapperState createState() => _FriendWrapperState();
}

class _FriendWrapperState extends State<FriendWrapper> {
  final bottomBarIndex = 2;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: friendlistAppBar(context, 'Vinalisti'),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: <Widget>[
            FriendList(),
            FindFriends(),
          ],
        ),

        bottomNavigationBar: BottomBar(currentTab: bottomBarIndex),
        floatingActionButton: HomeFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
