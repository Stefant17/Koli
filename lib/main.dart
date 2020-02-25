import 'package:flutter/material.dart';
import 'package:koli/models/user.dart';
import 'package:koli/screens/overview/overview.dart';
import 'package:koli/screens/wrapper.dart';
import 'package:koli/services/authService.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        //home: Wrapper(),
        routes: {
          '/': (context) => Wrapper(),
          '/Yfirlit': (context) => Overview(),

        },
      ),
    );
  }
}