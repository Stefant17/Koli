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
          onSelected: (List choice) {
            reroute(choice[1]);
          },

          icon: Icon(Icons.menu),
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
        ),
        onPressed: () {
          reroute('Prófíll');
        },
      ),
    ],
  ); //AppBar
}