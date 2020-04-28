import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/screens/home/bla.dart';
import 'package:koli/screens/home/home.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/shared/home_appbar.dart';

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override void initState() { super.initState(); }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: homeAppBar(context, 'Heima'),
        backgroundColor: Color(0xFF2D2E2E),

        body: TabBarView(
          children: <Widget>[
            Home(),
            //Bla(),
          ],
        ),
        floatingActionButton: HomeFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}
