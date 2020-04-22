import 'package:flutter/material.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/dataService.dart';
import 'package:provider/provider.dart';

class FriendLeaderboard extends StatefulWidget {
  @override
  _FriendLeaderboardState createState() => _FriendLeaderboardState();
}

class _FriendLeaderboardState extends State<FriendLeaderboard> {
  List<UserProfile> friends;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Container(
      child: StreamBuilder<List<UserProfile>>(
        stream: DatabaseService(uid: user.uid).friendsAndCo2,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            friends = snapshot.data;

            return Column(
              children: <Widget>[
                Text(
                  'Topplisti vina',
                ),

                Expanded(
                  child: ListView(
                    children: friends.map((friend) {
                      return Row(
                        children: <Widget>[
                          Text('${friend.co2ForCurrentMonth}\t'),
                          Text(friend.username),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          } else {
            return Text('loading');
          }
        }
      )
    );
  }
}
