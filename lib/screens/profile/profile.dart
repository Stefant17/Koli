import 'package:flutter/material.dart';
import 'package:koli/models/meKoli_avatar.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<MeKoliAvatar>(
      stream: DatabaseService(uid: user.uid).meKoliAvatar,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          MeKoliAvatar avatar = snapshot.data;

          return Scaffold(
            appBar: appBar(context, 'Prófíll'),
            body: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        avatar.face,
                        width: 250,
                        height: 300,
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(50, 50, 0, 0),
                        child: Image.asset(
                          avatar.eyes,
                          width: 150,
                          height: 150,
                        ),
                      ),

                      avatar.eyebrows != '' ? Container(
                        padding: EdgeInsets.fromLTRB(55, 20, 0, 0),
                        child: Image.asset(
                          //'assets/images/meKoli/meKoli_mouth7.PNG',
                          avatar.eyebrows,
                          width: 150,
                          height: 150,
                        ),
                      ) : Container(),

                      Container(
                        padding: EdgeInsets.fromLTRB(55, 140, 0, 0),
                        child: Image.asset(
                          avatar.mouth,
                          width: 150,
                          height: 150,
                        ),
                      ),

                      avatar.beard != '' ? Container(
                        padding: EdgeInsets.fromLTRB(55, 120, 0, 0),
                        child: Image.asset(
                          avatar.beard,
                          width: 150,
                          height: 150,
                        ),
                      ) : Container(),
                    ],
                  ),
                ),


                RaisedButton(
                  child: Text('meKoli'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/meKoli stillingar', arguments: {
                      'meKoli': avatar,
                    });
                  },
                ),

                RaisedButton(
                  child: Text('Mataræði'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/Mataræði stillingar');
                  },
                )
              ],
            ),
            bottomNavigationBar: BottomBar(),
          );
        } else {
          return Scaffold(
            appBar: appBar(context, 'Prófíll'),
            body: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.face,
                    size: 300,
                  )
                ),


                RaisedButton(
                  child: Text('meKoli'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/meKoli stillingar', arguments: {
                      'meKoli': null,
                    });
                  },
                ),

                RaisedButton(
                  child: Text('Mataræði'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/Mataræði stillingar');
                  },
                )
              ],
            ),
            bottomNavigationBar: BottomBar(),
          );
        }
      }
    );
  }
}
