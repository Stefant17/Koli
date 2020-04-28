import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/screens/transactions/transactions.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/shared/overview_appbar.dart';

class TransactionWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: overviewAppBar(context, 'Færslur'),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: <Widget>[
            Transactions(),
            //Text('blabla')
          ],
        ),

        bottomNavigationBar: BottomBar(),
        floatingActionButton: HomeFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
