import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/constants/constants.dart';

var constants = Constants();

Widget statisticsAppBar (var context){
  void reroute(String choice) {
    if(choice == 'Heim') {
      Navigator.pushNamed(context, '/');
    } else {
      Navigator.pushNamed(context, '/' + choice);
    }
  }

  return AppBar(
    backgroundColor: Colors.grey[900],
    elevation: 0.0,
    automaticallyImplyLeading: false,

    // Dropdown list, user profile, chart tabs
    actions: <Widget>[
      Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 270.0, 0.0),
        alignment: Alignment.topLeft,
        child: PopupMenuButton(
          onSelected: (List choice) {
            reroute(choice[1]);
          },

          icon: Icon(
            Icons.menu,
            size: 35,
          ),
          itemBuilder: (BuildContext context) {
            return constants.menuList.map((List item) {
              return PopupMenuItem<List>(
                value: item,
                child: Row(
                  children: <Widget> [
                    Icon(
                      item[0],
                      color: Colors.black
                    ),

                    SizedBox(width: 20),

                    Text('${item[1]}'),
                  ]
                ),
              );
            }).toList();
          },
        ),
      ),

      FlatButton(
        child: Icon(
          Icons.face,
          color: Colors.white,
          size: 35,
        ),
        onPressed: () {
          reroute('Prófíll');
        },
      ),
    ],

    bottom: TabBar(
      indicatorColor: Colors.white,
      tabs: [
        Tab(icon: Icon(FontAwesomeIcons.solidChartBar)),
        Tab(icon: Icon(FontAwesomeIcons.chartLine)),
        Tab(icon: Icon(FontAwesomeIcons.chartPie)),
      ],
    ),
  ); //AppBar
}