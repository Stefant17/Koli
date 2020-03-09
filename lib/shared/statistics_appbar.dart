import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/constants/constants.dart';

var constants = Constants();

Widget statisticsAppBar (var context){
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
          onSelected: (String choice) {
            if(choice == 'Heim') {
              Navigator.pushNamed(context, '/');
            } else {
              Navigator.pushNamed(context, '/' + choice);
            }
          },

          icon: Icon(Icons.menu),
          itemBuilder: (BuildContext context) {
            return constants.menuList.map((String item) {
              return PopupMenuItem<String>(
                value: item,
                child: Text('$item'),
              );
            }).toList();
          },
        ),
      ),

      FlatButton(
        child: Icon(
          Icons.face,
          color: Colors.white,
        ),
        onPressed: () {

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