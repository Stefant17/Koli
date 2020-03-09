import 'package:flutter/material.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: appBar(context),
      body: Column(
        children: <Widget>[
          StreamBuilder<UserProfile>(
            stream: DatabaseService(uid: user.uid).userProfile,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                UserProfile userData = snapshot.data;
                return Text('${userData.firstName}');
              } else {
                return Text('No data found');
              }
            }
          ),
        ],
      ),
    );
  }
}
