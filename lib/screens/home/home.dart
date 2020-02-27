import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/date.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/authService.dart';
import 'package:koli/services/dataService.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  var currentDate = DateTime.now();
  var constants = Constants();

  Date getCurrentDate() {
    return Date(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserProfile>(
      stream: DatabaseService(uid: user.uid).userProfile,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserProfile userData = snapshot.data;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              //title: Text('Koli'),
              //centerTitle: true,
              backgroundColor: Colors.grey[400],
              elevation: 0.0,
              automaticallyImplyLeading: false,

              // Dropdown list, user profile
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 270.0, 0.0),
                  alignment: Alignment.topLeft,
                  child: PopupMenuButton(
                    onSelected: (String choice) {
                      Navigator.pushNamed(context, '/' + choice);
                    },

                    icon: Icon(Icons.menu),
                    itemBuilder: (BuildContext context) {
                      return constants.menuList.map((String item) {
                        return PopupMenuItem<String> (
                          value: item,
                          child: Text('$item'),
                        );
                      }).toList();
                    },
                  ),
                ),

                FlatButton.icon(
                  icon: Icon(Icons.face),
                  label: Text(''),
                  onPressed: () {

                  },
                ),
              ],
            ),

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
          );
        } else {
          return Scaffold();
        }
      }
    );
  }
}
