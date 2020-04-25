import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/screens/charity/kolvidur_donation.dart';
import 'package:koli/screens/charity/kolvidur_info.dart';
import 'package:koli/shared/charity_appbar.dart';
import '../../shared/bottom_navbar.dart';

class CharityScreen extends StatefulWidget {
  @override
  _CharityScreenState createState() => _CharityScreenState();
}

class _CharityScreenState extends State<CharityScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: charityAppBar(context, 'Kolefnisjöfnun'),
        body: TabBarView(
          children: <Widget>[
            KolvidurInfo(),
            KolvidurDonation(),
          ],
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomBar(),
        floatingActionButton: HomeFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
