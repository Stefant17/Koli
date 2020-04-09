import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/forms/add_card_form.dart';
import 'package:koli/models/badge.dart';
import 'package:koli/models/date.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/screens/home/animatedCounter.dart';
import 'package:koli/services/authService.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/achievement_get.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/shared/loading.dart';
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

  List<Color> gradientList = [
    //Color(0xFF48A9A6),
    //Colors.greenAccent,
    Color(0xFFA5F8D3),
    Colors.blue,
  ];

  Date getCurrentDate() {
    return Date(currentDate);
  }

  void addNewBadge(Badge badge) {
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

    DatabaseService().getClimateChangeInfo();

    return StreamBuilder<UserProfile>(
      stream: DatabaseService(uid: user.uid).userProfile,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserProfile userData = snapshot.data;

          return Scaffold(
            backgroundColor: Color(0xFF2D2E2E),
            appBar: appBar(context, 'Heima'),

            body: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              color: Color(0xFF2D2E2E),
              child: ListView(
                children: <Widget> [
                  SizedBox(height: 20),
                  StreamBuilder<int>(
                    stream: DatabaseService(uid: user.uid).co2valueForCurrentMonth,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        int co2 = snapshot.data;

                        return Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 150,

                              child: Container(
                                padding: EdgeInsets.all(20),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  'Velkominn',
                                  style: TextStyle(
                                    color: Color(0xFFFAF9F9),
                                    fontSize: 30,
                                  )
                                ),
                              ),

                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  //begin: Alignment.bottomRight,
                                  colors: gradientList,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                          width: MediaQuery.of(context).size.width * 0.5 - 25,
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 20),
                                              Container(
                                                alignment: Alignment.bottomCenter,
                                                padding: const EdgeInsets.all(30.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 5,
                                                    color: Colors.blue[200],
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),

                                                child: Column(
                                                  children: <Widget>[
                                                    AnimatedCounter(co2: co2),
                                                    Text(
                                                      'sæti #31',
                                                      style: TextStyle(
                                                        color: Colors.blue[300],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),

                                              SizedBox(height: 20),
                                            ],
                                          ),

                                        decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5 - 25,
                                      height: 210,
                                      alignment: Alignment.centerLeft,
                                      child: Text('bla'),


                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          //begin: Alignment.bottomRight,
                                          colors: gradientList,
                                        ),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                SizedBox(width: 10),

                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5 - 25,
                                      height: 210,
                                      alignment: Alignment.centerLeft,
                                      child: Text('bla'),

                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          //begin: Alignment.bottomRight,
                                          colors: gradientList,
                                        ),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5 - 25,
                                      height: MediaQuery.of(context).size.width * 0.5 - 25,
                                      alignment: Alignment.centerLeft,
                                      child: Text('bla'),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          //begin: Alignment.bottomRight,
                                          colors: gradientList,
                                        ),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );

                        return Container(
                          alignment: Alignment.center,
                          color: Color(0xFF2D2E2E),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[


                              //SizedBox(width: 40),
                              //VerticalDivider(color: Colors.white),
                              SizedBox(width: 40),

                              /*
                              Container(
                                alignment: Alignment.topRight,
                                transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.face,
                                      size: 125,
                                      color: Colors.grey[600],
                                    ),
                                    Text(
                                      '${userData.firstName}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                               */
                            ],
                          ),
                        );
                      } else {
                        return Text('ya');
                      }
                    }
                  ),
                  /*
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

                   */


                  /*
                  RaisedButton(
                    elevation: 0,
                    color: Colors.blue,
                    child: Text(
                      'Tengja kort',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    onPressed: () {
                      Navigator.pushNamed(context, '/Nýtt kort');
                    },
                  ),

                   */
                ],
              ),
            ),

            bottomNavigationBar: BottomBar(),
          );
        } else {
          //return Loading();
          return Text('loading');
        }
      }
    );
  }
}
