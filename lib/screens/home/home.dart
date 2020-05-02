import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/badge.dart';
import 'package:koli/models/date.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/screens/home/animatedCounter.dart';
import 'package:koli/screens/home/category_pie_chart.dart';
import 'package:koli/screens/home/friend_leaderboard.dart';
import 'package:koli/screens/home/fun_facts.dart';
import 'package:koli/services/authService.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/services/location_service.dart';
import 'package:koli/shared/achievement_get.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  var currentDate;
  var constants;

  bool checkedForBadges;
  bool checkedForNewCardTrans;

  List<Color> gradientList;

  //LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();

    currentDate = DateTime.now();
    constants = Constants();
    checkedForBadges = false;
    checkedForNewCardTrans = false;

    gradientList = [
      //Color(0xFF48A9A6),
      //Colors.greenAccent,
      Color(0xFFA5F8D3),
      Color(0xFF00b0ff),
    ];
  }

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

    if(!checkedForBadges) {
      DatabaseService(uid: user.uid).awardBadges(this.addNewBadge);
      checkedForBadges = true;
    }

    DatabaseService(uid: user.uid).updateFriendsCo2();
    DatabaseService(uid: user.uid).checkForNewCardTransactions();

    return StreamBuilder<UserProfile>(
      stream: DatabaseService(uid: user.uid).userProfile,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserProfile userData = snapshot.data;

          return Container(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              color: Color(0xFF2D2E2E),
              child: ListView(
                children: <Widget> [
                  SizedBox(height: 20),
                  StreamBuilder<int>(
                    stream: DatabaseService(uid: user.uid).co2valueForCurrentMonth,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        int co2 = snapshot.data - (userData.treesPlanted * 21) ~/ 12;// - treesPlanted;

                        return Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 150,

                              child: Container(
                                padding: EdgeInsets.all(20),
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Velkominn',
                                        style: TextStyle(
                                          color: Color(0xFFFAF9F9),
                                          fontSize: 30,
                                        )
                                      ),
                                    ),

                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        getCurrentDate().getDayAndMonth(),
                                        style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 20,
                                        ),
                                      ),
                                    )
                                  ],
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
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.white.withOpacity(0.3),
                                    BlendMode.dstATop,
                                  ),
                                  image: AssetImage(
                                    'assets/images/trees.jpg',
                                  ),
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
                                      height: 160,
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topRight,
                                            padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),

                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                  child: Text(
                                                    'Kolefnisspor',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFFFAF9F9).withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(height: 10),

                                                Container(
                                                  child: AnimatedCounter(co2: co2),
                                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                ),

                                                /*
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                                  child: Text(
                                                    'sæti #31',
                                                    style: TextStyle(
                                                      color: Color(0xFFFAF9F9),
                                                    ),
                                                  ),
                                                ),

                                                 */
                                              ],
                                            ),
                                          ),

                                          Container(
                                            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                                            alignment: Alignment.centerLeft,
                                            child: InkWell(
                                              child: Icon(
                                                FontAwesomeIcons.shareAlt,
                                                color: Colors.white.withOpacity(0.6),
                                              ),

                                              onTap: () {
                                                Share.share(
                                                  'Ég er með kolefnissporið $co2 í Kola!'
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),

                                        decoration: BoxDecoration(
                                          color: Color(0xFFAEA4BF),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),

                                          gradient: LinearGradient(
                                            //begin: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFF1F7A8C),
                                              Color(0xFFAEA4BF),
                                            ],
                                          ),

                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                              Colors.white.withOpacity(0.3),
                                              BlendMode.dstATop,
                                            ),
                                            image: AssetImage(
                                              'assets/images/footprints_beach.jpg',
                                            ),
                                          ),
                                        ),
                                    ),

                                    SizedBox(height: 10),

                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5 - 25,
                                      height: 210,
                                      alignment: Alignment.centerLeft,
                                      child: FriendLeaderboard(),//Text('bla'),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          //begin: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF2c818b),
                                            Color(0xFF4bc3d1),
                                          ],
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
                                      child: CategoryPieChart(),//Text('Leaderboard'),

                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          colors: [
                                            Color(0xFFa5f8d3),
                                            Colors.blue,
                                            //Color(0xFFa9cef4),
                                            //Color(0xFF577399),
                                            //Color(0xFF495867),
                                          ],
                                        ),
                                        
                                        color: Color(0xFF028090).withOpacity(0.8),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),


                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                            Colors.white.withOpacity(0.2),
                                            BlendMode.dstATop,
                                          ),
                                          image: AssetImage(
                                            'assets/images/shopping.jpg',
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.5 - 25,
                                      height: 160,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            'Vissir þú?',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          SizedBox(height: 10),

                                          Expanded(
                                            child: FunFacts()
                                          ),
                                        ],
                                      ),//Text('bla'),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          colors: [
                                            Color(0xFF2c818b),
                                            Color(0xFF4bc3d1),
                                          ],
                                        ),
                                        color: Colors.grey[600],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),

                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                            Colors.white.withOpacity(0.3),
                                            BlendMode.dstATop,
                                          ),
                                          image: AssetImage(
                                            'assets/images/forest.jpg',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Text('ya');
                      }
                    }
                  ),

                  SizedBox(height: 10),
                  /*
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,

                    child: Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Velkominn',
                                style: TextStyle(
                                  color: Color(0xFFFAF9F9),
                                  fontSize: 30,
                                )
                            ),
                          ),

                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              getCurrentDate().getDayAndMonth(),
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Color(0xFF134c53),
                          Color(0xFF2c818b),
                        ],
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.3),
                          BlendMode.dstATop,
                        ),
                        image: AssetImage(
                          'assets/images/trees.jpg',
                        ),
                      ),
                    ),
                  ),

                   */

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
                ],
              ),
            ),
          );
        } else {
          //return Loading();
          return Text('loading');
        }
      }
    );
  }
}
