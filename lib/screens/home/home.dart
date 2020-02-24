import 'package:flutter/material.dart';
import 'package:koli/services/authService.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Koli'),
        backgroundColor: Colors.grey[400],
        elevation: 0.0,

        // Dropdown list, user profile
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text(''),
            onPressed: () {

            },
          )
        ],
      ),

      body: Container(
        child: Column(
          children: <Widget> [
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
