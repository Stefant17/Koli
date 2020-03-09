import 'package:flutter/material.dart';
import 'package:koli/models/user.dart';
import 'package:koli/screens/badges/badges.dart';
import 'package:koli/screens/overview/overview.dart';
import 'package:koli/screens/profile/profile.dart';
import 'package:koli/screens/statistics/statistics.dart';
import 'package:koli/screens/wrapper.dart';
import 'package:koli/services/authService.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        //home: Wrapper(),
        routes: {
          '/': (context) => Wrapper(),
          '/Yfirlit': (context) => Overview(),
          '/Tölfræði': (context) => Statistics(),
          '/Orður': (context) => Badges(),
          '/Prófíll': (context) => Profile(),
        },
      ),
    );
  }
}