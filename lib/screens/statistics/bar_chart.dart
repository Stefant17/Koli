import 'package:flutter/material.dart';
import 'package:koli/models/co2_by_day.dart';
import 'package:koli/models/co2_by_month.dart';
import 'package:koli/models/co2_by_week.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/dataService.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MonthTotal {
  String month;
  int totalCo2;

  MonthTotal({ this.month, this.totalCo2 });
}

class BarChart extends StatefulWidget {
  String uid;

  BarChart({ this.uid });

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  String timeSetting = 'months';

  //https://www.youtube.com/watch?v=GwDMwnELTP4
  List<charts.Series<MonthTotal, String>> chartMonthData = List<charts.Series<MonthTotal, String>>();

  void generateMonthChartData(CO2ByMonth data, int treesPlanted) {
    List<MonthTotal> monthTotal = [];
    for(var i = 0; i < data.co2Values.length; i++) {
      monthTotal.add(
        MonthTotal(
          month: data.months[i],
          totalCo2: data.co2Values[i] - (treesPlanted * 21) ~/ 12,
        )
      );
    }

    chartMonthData.add(
      charts.Series(
        id: 'Blabla',
        data: monthTotal,
        domainFn: (MonthTotal m,_) => m.month,
        measureFn: (MonthTotal m,_) => m.totalCo2
        //labelAccessorFn: (MonthTotal m,_) => '${m.percentage}'
        //colorFn: (MonthTotal m,_) => charts.ColorUtil.fromDartColor(m.color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile>(
      stream: DatabaseService(uid: widget.uid).userProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserProfile userProfile = snapshot.data;

          return Column(
              children: <Widget>[
                (timeSetting == 'months') ?
                StreamBuilder<CO2ByMonth>(
                  stream: DatabaseService(uid: widget.uid).co2ByMonth,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      CO2ByMonth co2 = snapshot.data;
                      generateMonthChartData(co2, userProfile.treesPlanted);

                      return Container(
                        child: Expanded(
                          child: charts.BarChart(
                            chartMonthData,
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                )
                    : (timeSetting == 'weeks') ?
                StreamBuilder<CO2ByWeek>(
                  stream: DatabaseService(uid: widget.uid).co2ByWeek,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          child: Text('')
                      );
                    } else {
                      return Container();
                    }
                  },
                )
                    : (timeSetting == 'days') ?
                StreamBuilder<CO2ByDay>(
                  stream: DatabaseService(uid: widget.uid).co2ByDay,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          child: Text('')
                      );
                    } else {
                      return Container();
                    }
                  },
                )
                    : Container(
                    child: Text('')
                ),
              ]
          );
        } else {
          return Text('ye');
        }
      }
    );
  }
}
