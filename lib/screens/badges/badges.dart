import 'package:flutter/material.dart';
import 'package:koli/models/badge.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/views/badge_view.dart';
import 'package:provider/provider.dart';

class Badges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<Object>(
      stream: DatabaseService(uid: user.uid).userBadges,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          List<Badge> badges = snapshot.data;

          return Scaffold(
            appBar: appBar(context),
            body: Column(
              children: badges.map((badge){
                return BadgeView(
                  badge: badge,
                );
              }).toList()
            ),
          );
        } else {
          return Text('NOTHING!');
        }
      }
    );
  }
}
