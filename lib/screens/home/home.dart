import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/badge.dart';
import 'package:koli/models/date.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/authService.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/achievement_get.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:koli/shared/appbar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  var currentDate = DateTime.now();
  var constants = Constants();
  bool checkedForBadges = false;
  bool checkedForNewCardTrans = false;

  Date getCurrentDate() {
    return Date(currentDate);
  }

  Function addNewBadge(Badge badge) {
    achievementGet(this.context, badge);
    setState(() {
      checkedForBadges = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if(!checkedForNewCardTrans) {
      DatabaseService(uid: user.uid).checkForNewCardTransactions();
      checkedForNewCardTrans = true;
    }

    if(!checkedForBadges) {
      DatabaseService(uid: user.uid).awardBadges(this.addNewBadge);
      checkedForBadges = true;
    }

    return StreamBuilder<UserProfile>(
      stream: DatabaseService(uid: user.uid).userProfile,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserProfile userData = snapshot.data;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar(context),

            body: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget> [
                  Container(
                    //margin: EdgeInsets.fromLTRB(50, 20, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(
                            '${getCurrentDate().getCurrentDate()}',
                            style: TextStyle(
                              fontSize: 40,
                            ),
                          ),
                        ),

                        Container(
                          child: Text(
                            '${getCurrentDate().getCurrentWeekday()}',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  StreamBuilder<int>(
                    stream: DatabaseService(uid: user.uid).co2valueForCurrentMonth,
                    builder: (context, snapshot) {
                      int co2 = snapshot.data;
                      return Container(
                        child: Text(
                          '$co2 kg',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.blue
                          ),
                        ),
                      );
                    }
                  ),

                  SizedBox(height: 50),
                  //HomeUserInfo(),
                  Text('${userData.firstName} ${userData.lastName}'),
                  SizedBox(height: 50),

                  RaisedButton(
                    color: Colors.black,
                    child: Text(
                      'Skrá út',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
              ),
            ),

            bottomNavigationBar: BottomBar(),
          );
        } else {
          print('no data');
          return Scaffold();
        }
      }
    );
  }
}
