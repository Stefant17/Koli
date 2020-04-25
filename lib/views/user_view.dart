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
              Icon(
                Icons.face,
                size: 50,
              ),

              SizedBox(width: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${user.username}',
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.black
                    ),
                  ),

                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),

              Container(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  child: Text('+'),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: Colors.black,
                        width: 2,
                      )
                  ),
                  onPressed: () {
                    DatabaseService(uid: currentUser.uid).addFriend(user.uid);
                  },
                ),
              ),
            ]
          ),
        ]
      ),
    );
  }
}