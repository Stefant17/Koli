import 'package:flutter/material.dart';
import 'package:koli/screens/overview/overview.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/shared/overview_appbar.dart';

class OverViewWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: overviewAppBar(context, 'Yfirlit'),
        //backgroundColor: Colors.white,
        body: TabBarView(
          children: <Widget>[
            Overview(),
            Text('blabla')
          ],
        ),

        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}
