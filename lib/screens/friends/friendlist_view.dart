import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/views/user_view.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/views/friend_view.dart';
import 'package:provider/provider.dart';

class FriendList extends StatefulWidget {
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final bottomBarIndex = 2;

  List<UserProfile> userQueryResult;
  String friendEmail = '';
  String searchQuery = '';

  void executeSearchQuery(User user) {
    setState(() async {
      userQueryResult = await DatabaseService(uid: user.uid).userSearch(searchQuery);
    });
  }

  void friendInviteDialog(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sláðu inn netfang vinar'),
          content: TextField(
            onChanged: (val) {
              setState(() {
                friendEmail = val;
              });
            },
          ),
          actions: <Widget>[
            Container(
              alignment: Alignment.bottomLeft,
              child: RaisedButton(
                elevation: 0,
                child: Text('Hætta við'),
                onPressed: () {
                  friendEmail = '';
                  Navigator.pop(context);
                },
              ),
            ),

            RaisedButton(
              elevation: 0,
              child: Text('Staðfesta'),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  Container inviteFriendButton(context) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.bottomLeft,
      child: RaisedButton(
        elevation: 0,
        color: Colors.blue,
        child: Text(
          '+ bjóða vini',
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        onPressed: () {
          friendInviteDialog(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<List<UserProfile>>(
      stream: DatabaseService(uid: user.uid).friendList,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          List<UserProfile> friends = snapshot.data;

          return ListView(
            children: <Widget>[
              Column(
                children: friends.map((friend) {
                  return FriendView(
                    friend: friend
                  );
                }).toList(),
              ),
            ]
          );
        } else {
          return Container();
          //return inviteFriendButton(context);
        }
      }
    );
  }
}
