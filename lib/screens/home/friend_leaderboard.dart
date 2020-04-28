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
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 10),

                Expanded(
                  child: ListView(
                    children: friends.map((friend) {
                      return Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '${friends.indexOf(friend) + 1}\t',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${friend.username}\t',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${friend.co2ForCurrentMonth} kg',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
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
