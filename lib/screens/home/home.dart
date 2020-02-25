import 'package:flutter/material.dart';
import 'package:koli/models/date.dart';
import 'package:koli/services/authService.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  var currentDate = DateTime.now();

  List<Widget> dropdownButtons = [
    FlatButton(
      child: Text(
        'Yfirlit',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
      },
    ),
    FlatButton(
      child: Text(
        'Yfirlit',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
      },
    ),
    FlatButton(
      child: Text(
        'Dags Yfirlit',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {},
    ),
    FlatButton(
      child: Text(
        'Tölfræði',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
      },
    ),
    FlatButton(
      child: Text(
        'Orður',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
      },
    ),
  ];

  List<String> menuList = [
    'Yfirlit',
    'Dags yfirlit',
    'Tölfræði',
    'Orður',
  ];

  bool showMenu = false;

  Date getCurrentDate() {
    return Date(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        //title: Text('Koli'),
        //centerTitle: true,
        backgroundColor: Colors.grey[400],
        elevation: 0.0,

        // Dropdown list, user profile
        actions: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 270.0, 0.0),
            alignment: Alignment.topLeft,
            child: PopupMenuButton(
              icon: Icon(Icons.menu),
              itemBuilder: (BuildContext context) {
                return menuList.map((String item) {
                  return PopupMenuItem<String> (
                    value: item,
                    child: Text('$item'),
                  );
                }).toList();
              },
            ),
          ),
          /*
          FlatButton.icon(
            padding: EdgeInsets.only(right: 280),
            icon: Icon(Icons.menu),
            label: Text(''),
            onPressed: () {
              this.toggleMenu();
            },
          ),

           */

          FlatButton.icon(
            icon: Icon(Icons.face),
            label: Text(''),
            onPressed: () {

            },
          ),
        ],
      ),

      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget> [

            /*
            Visibility(
              visible: showMenu,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 270, 0),
                child: menu(),
              ),
            ),

             */


            Container(
              margin: EdgeInsets.fromLTRB(50, 20, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${getCurrentDate().getCurrentDate()}',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ),

                  Container(
                    child: Text(
                      '${getCurrentDate().getCurrentWeekday()}',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            RaisedButton(
              color: Colors.black,
              child: Text(
                'Skrá út',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
