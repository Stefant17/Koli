import 'package:flutter/material.dart';
import 'package:koli/models/user_profile.dart';

class FriendView extends StatelessWidget {
  UserProfile friend;
  FriendView({ this.friend });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '${friend.firstName}',
            style: TextStyle(
              fontSize: 20,
              color: friend.pendingInvite ? Colors.grey : Colors.black,
            ),
          ),
        ]
      ),
    );
  }
}
