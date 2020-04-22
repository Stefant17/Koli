import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:koli/models/co2_by_category.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:provider/provider.dart';

class CategoryTotal {
  String category;
  int totalCo2;

  CategoryTotal({ this.category, this.totalCo2 });
}

class CategoryPieChart extends StatelessWidget {
  List<charts.Series<CategoryTotal, String>> chartCategoryData
    = List<charts.Series<CategoryTotal, String>>();

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
            totalCo2: data.co2Values[i]
          )
        );
      }
    }

    chartCategoryData.add(
      charts.Series(
        id: 'Blabla',
        data: categoryTotal,
        domainFn: (CategoryTotal c,_) => c.category,
        measureFn: (CategoryTotal c,_) => c.totalCo2,
        labelAccessorFn: (CategoryTotal c,_) => '${c.category}, ${c.totalCo2}kg', //'${m.percentage}'
        colorFn: (_, index) => charts.MaterialPalette.teal.makeShades(categoryTotal.length)[index],
        fillColorFn: (_, __) => charts.MaterialPalette.transparent,
        //colorFn: (MonthTotal m,_) => charts.ColorUtil.fromDartColor(m.color),
      ),
    );



    for(var i = 0; i < categoryTotal.length; i++) {
      //print(categoryTotal[i].category + ': ' + categoryTotal[i].totalCo2.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<Object>(
      stream: DatabaseService(uid: user.uid).co2ByCategoryForCurrentMonth,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          CO2ByCategory data = snapshot.data;
          generateData(data);

          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Expanded(
                    child: charts.PieChart(
                      chartCategoryData,
                      animate: true,
                      animationDuration: Duration(seconds: 1),
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 100,
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition
                                    .inside
                            )
                          ]
                      ),
                    ),
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
