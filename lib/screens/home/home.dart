import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/date.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/authService.dart';
import 'package:koli/services/dataService.dart';
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
