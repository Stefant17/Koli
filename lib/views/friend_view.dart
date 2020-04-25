import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/models/user_profile.dart';

class FriendView extends StatelessWidget {
  UserProfile friend;
  FriendView({ this.friend });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.face,
            size: 50,
          ),

          SizedBox(width: 20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${friend.username}',
                style: TextStyle(
                  fontSize: 23,
                  color: friend.pendingInvite ? Colors.grey : Colors.black,
                ),
              ),

              Text(
                '${friend.firstName} ${friend.lastName}',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              alignment: Alignment.centerRight,
              child: !friend.pendingInvite ? InkWell(
                child: Icon(
                  FontAwesomeIcons.commentDots,
                  size: 35,
                ),

                onTap: () {

                },
              ): Text(
                'Vinarbeiðni\n     send',
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}
