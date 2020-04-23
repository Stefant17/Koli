import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/co2_by_category.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:provider/provider.dart';

class CategoryTotal {
  String category;
  int totalCo2;
  Color color;

  CategoryTotal({ this.category, this.totalCo2, this.color });
}

class CategoryPieChart extends StatefulWidget {
  @override
  _CategoryPieChartState createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  //List<charts.Series<CategoryTotal, String>> chartCategoryData =
  //  List<charts.Series<CategoryTotal, String>>();
  Map<String, double> dataMap = new Map();
  List<Color> colors = [];
  var icons = Constants().categoryIcons;


  @override
  void initState() {
    super.initState();
  }

  void generateData(CO2ByCategory data) {
    List<CategoryTotal> categoryTotal = [];
    for(var i = 0; i < data.categories.length; i++) {
      bool foundDuplicateCategory = false;

      for(var j = 0; j < categoryTotal.length; j++) {
        if(data.categories[i] == categoryTotal[j].category) {
          categoryTotal[j].totalCo2 += data.co2Values[i];
          foundDuplicateCategory = true;
          break;
        }
      }

      if(!foundDuplicateCategory) {
        categoryTotal.add(
          CategoryTotal(
            category: data.categories[i],
            totalCo2: data.co2Values[i],
            color: Color(icons[data.categories[i]]['Color']),
          )
        );
      }
    }

    for(var i = 0; i < categoryTotal.length; i++) {
      dataMap.putIfAbsent(categoryTotal[i].category, () => categoryTotal[i].totalCo2 + 0.0);
      colors.add(categoryTotal[i].color);
    }
    /*

    chartCategoryData.add(
      charts.Series(
        id: 'Blabla',
        data: categoryTotal,
        domainFn: (CategoryTotal c,_) => c.category,
        measureFn: (CategoryTotal c,_) => c.totalCo2,
        labelAccessorFn: (CategoryTotal c,_) => c.category,
        fillColorFn: (_, __) => charts.MaterialPalette.transparent,
        colorFn: (CategoryTotal c,_) => charts.ColorUtil.fromDartColor(c.color),
      ),
    );

    for(var i = 0; i < categoryTotal.length; i++) {
      //print(categoryTotal[i].category + ': ' + categoryTotal[i].totalCo2.toString());
    }

     */
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<Object>(
      stream: DatabaseService(uid: user.uid).co2ByCategoryForCurrentMonth,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          CO2ByCategory data = snapshot.data;
          if(data.categories.isEmpty) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Þegar þú ert kominn með nokkrar færslur, '
                'er hægt að sjá yfirlit yfir vöruflokka hér',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            );
          }

          generateData(data);

          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Expanded(
                    child: PieChart(
                      dataMap: dataMap,
                      chartRadius: 200,
                      colorList: colors,
                      chartLegendSpacing: 30,
                      showChartValuesOutside: true,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      chartType: ChartType.ring,
                    ),

                    /*
                    child: charts.PieChart(
                      chartCategoryData,
                      animate: true,
                      animationDuration: Duration(seconds: 1),
                      defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 60,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.inside,
                          )
                        ]
                      ),
                    ),

                     */
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hvaðan kemur\n  sporið þitt?',
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),


              ],
            ),
          );
        } else {
          return Text('loading');
        }
      }
    );
  }
}
