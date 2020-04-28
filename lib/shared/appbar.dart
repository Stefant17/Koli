import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/services/authService.dart';

var constants = Constants();

Widget appBar (var context, String title){
  final AuthService _auth = AuthService();

  void reroute(String choice) async {
    if(choice == 'Heim') {
      Navigator.pushNamed(context, '/');
    }

    else if(choice == 'Skrá út') {
      print('check');
      await _auth.signOut();
    }

    else {
      Navigator.pushNamed(context, '/' + choice);
    }
  }

  return AppBar(
    // title: Text('Koli'),
    title: Row(
      children: <Widget>[
        PopupMenuButton(
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
                          color: Colors.black,
                      ),

                      SizedBox(width: 20),

                      Text('${item[1]}'),
                    ]
                ),
              );
            }).toList();
          },
        ),
        SizedBox(width: 30),
        Text('$title'),
      ],
    ),
    backgroundColor: Colors.grey[900],
    elevation: 0.0,
    automaticallyImplyLeading: false,

    // Dropdown list, user profile
    actions: <Widget>[
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
  ); //AppBar
}