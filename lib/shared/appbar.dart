import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';

var constants = Constants();

Widget appBar (var context){
  void reroute(String choice) {
    if(choice == 'Heim') {
      Navigator.pushNamed(context, '/');
    } else {
      Navigator.pushNamed(context, '/' + choice);
    }
  }

  return AppBar(
    // title: Text('Koli'),
    // centerTitle: true,
    backgroundColor: Colors.grey[900],
    elevation: 0.0,
    automaticallyImplyLeading: false,

    // Dropdown list, user profile
    actions: <Widget>[
      Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 270.0, 0.0),
        alignment: Alignment.topLeft,
        child: PopupMenuButton(
          onSelected: (String choice) {
            reroute(choice);
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
          reroute('Prófíll');
        },
      ),
    ],
  ); //AppBar
}