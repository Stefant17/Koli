import 'package:flutter/material.dart';
import 'package:koli/models/user.dart';
import 'package:koli/screens/authenticate/authenticate.dart';
import 'package:koli/screens/home/home_wrapper.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if(user == null) {
      return Authenticate();
    } else {
      return HomeWrapper();
    }
  }
}