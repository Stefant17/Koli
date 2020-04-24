import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/user.dart';
import 'package:koli/screens/statistics/bar_chart.dart';
import 'package:koli/screens/statistics/line_chart.dart';
import 'package:koli/screens/statistics/pie_chart.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/shared/statistics_appbar.dart';
import 'package:provider/provider.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

// TODO: implement trees planted modifier to stats
class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: statisticsAppBar(context, 'Tölfræði'),
        body: TabBarView(
          children: <Widget>[
            BarChart(uid: user.uid),
            LineChart(uid: user.uid),
            PieChart(uid: user.uid),
          ],
        ),

        bottomNavigationBar: BottomBar(),
        floatingActionButton: Constants().homeFAB(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}