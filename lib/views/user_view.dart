import 'package:flutter/material.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/dataService.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  UserProfile user;
  UserView({ this.user });

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row (
            children: <Widget>[
              Text(
                '${user.firstName}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),

              RaisedButton(
                child: Text('+'),
                onPressed: () {
                  DatabaseService(uid: currentUser.uid).addFriend(user.uid);
                },
              ),
            ]
          ),
        ]
      ),
    );
  }
}