import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';
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

          return Scaffold(
            appBar: appBar(context, 'Vinir'),
            body: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  color: Colors.grey[900],
                  child: TextField(
                    style: TextStyle(
                        color: Colors.white
                    ),
                    decoration: InputDecoration(
                      hintText: 'Leita að notendum',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                      prefixIcon: Icon(
                        FontAwesomeIcons.search,
                        color: Colors.white,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() => searchQuery = val);
                      executeSearchQuery(user);
                    },
                  ),
                ),

                Expanded(
                  child: ListView(
                    children: <Widget>[
                      searchQuery == '' ? Column(
                        children: friends.map((friend) {
                          return FriendView(
                            friend: friend
                          );
                        }).toList(),
                      )
                      : userQueryResult != null ?
                      Column(
                        children: userQueryResult.map((user) {
                          return UserView(
                            user: user,
                          );
                        }).toList(),
                      )
                      : Container(),

                      //SizedBox(height: 20),
                      //inviteFriendButton(context),
                    ]
                  ),
                ),
              ],
            ),

            bottomNavigationBar: BottomBar(currentTab: bottomBarIndex),
            floatingActionButton: Constants().homeFAB(context),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          );
        } else {
          return Container();
          //return inviteFriendButton(context);
        }
      }
    );
  }
}
