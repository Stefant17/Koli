import 'package:flutter/material.dart';
import 'package:koli/models/co2_by_day.dart';
import 'package:koli/models/co2_by_month.dart';
import 'package:koli/models/co2_by_week.dart';
import 'package:koli/services/dataService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:koli/models/date.dart';

class MonthTotal {
  int monthNumber;
  int totalCo2;

  MonthTotal({ this.monthNumber, this.totalCo2 });
}

class LineChart extends StatefulWidget {
  String uid;

  LineChart({ this.uid });

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  String timeSetting = 'months';
  Date date = Date(DateTime.now());
  static int currentMonth = DateTime.now().month;

  List<charts.Series<MonthTotal, int>> chartMonthData = List<charts.Series<MonthTotal, int>>();

  final monthCustomTickFormatter = charts.BasicNumericTickFormatterSpec((num value) {
    if(value == 0.0 || value == 13.0) {
      return '';
    }

    Date date2 = Date(DateTime.now());
    var month = date2.getMonthList()[value.toInt()];

    if(currentMonth >= 9) {
      return month[0];
    } else {
     return month;
    }
  });

  void generateMonthChartData(CO2ByMonth data) {
    List<MonthTotal> monthTotal = [];

    for(var i = 0; i < data.co2Values.length; i++) {
      monthTotal.add(
        MonthTotal(
          monthNumber: date.getMonthNumberFromString(data.months[i]),
          totalCo2: data.co2Values[i],
        )
      );
    }

    chartMonthData.add(
      charts.Series(
        id: 'Blabla',
        data: monthTotal,
        domainFn: (MonthTotal m,_) => m.monthNumber,
        measureFn: (MonthTotal m,_) => m.totalCo2
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        (timeSetting == 'months') ?
        StreamBuilder<CO2ByMonth> (
          stream: DatabaseService(uid: widget.uid).co2ByMonth,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              CO2ByMonth co2 = snapshot.data;
              generateMonthChartData(co2);

              return Container(
                child: Expanded (
                  child: charts.LineChart(
                    chartMonthData,
                    defaultRenderer: charts.LineRendererConfig(
                      includePoints: true,
                    ),

                    domainAxis: charts.NumericAxisSpec(
                      tickProviderSpec: charts.BasicNumericTickProviderSpec(desiredTickCount: currentMonth + 1),
                      tickFormatterSpec: monthCustomTickFormatter,
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        )
        :(timeSetting == 'weeks') ?
        StreamBuilder<CO2ByWeek> (
          stream: DatabaseService(uid: widget.uid).co2ByWeek,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return Container(
                  child: Text('')
              );
            } else {
              return Container();
            }
          },
        )
        :(timeSetting == 'days') ?
        StreamBuilder<CO2ByDay> (
          stream: DatabaseService(uid: widget.uid).co2ByDay,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return Container(
                  child: Text('')
              );
            } else {
              return Container();
            }
          },
        )
        :Container(
          child: Text('')
        ),
      ],
    );
  }
}
