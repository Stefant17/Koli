import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/badge.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/views/badge_view.dart';
import 'package:provider/provider.dart';

class Badges extends StatelessWidget {
  List<Row> constructRows(List<Badge> badges) {
    List<List<Badge>> badgeRowList = [];
    List<Badge> badgeRows = [];

    for(var i = 0; i < badges.length; i++) {
      badgeRows.add(badges[i]);
      if((i + 1) % 3 == 0) {
        badgeRowList.add(badgeRows);
        badgeRows = [];
      }
    }

    badgeRowList.add(badgeRows);
    List<Row> rowList = [];

    for(var i = 0; i < badgeRowList.length; i++) {
      rowList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: badgeRowList[i].map((badge) {
            return BadgeView(
              badge: badge,
            );
          }).toList() ,
        )
      );
    }
    return rowList;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<Object>(
      stream: DatabaseService(uid: user.uid).userBadges,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          List<Badge> badges = snapshot.data;

          return Scaffold(
            appBar: appBar(context, 'Orður'),
            body: Container(
              padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
              child: ListView(
                children: constructRows(badges),
              ),
            ),

            bottomNavigationBar: BottomBar(),
            floatingActionButton: Constants().homeFAB(context),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          );
        } else {
          return Text('NOTHING!');
        }
      }
    );
  }
}
