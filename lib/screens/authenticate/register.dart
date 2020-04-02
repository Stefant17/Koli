import 'package:flutter/material.dart';
import 'package:koli/services/authService.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
        title: Text(
          'Nýskráning',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget> [
          FlatButton.icon(
            icon: Icon(
              Icons.person,
              color: Colors.blueGrey,
            ),
            label: Text(
              'Innskráning',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget> [
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Netfang',
                ),
                validator: (val) => val.isEmpty ? 'Vinsamlegast sláðu inn netfang' : null,
                onChanged: (val) {
                  setState(() => email = val);
                }
              ),

              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Lykilorð',
                ),
                validator: (val) => val.length < 6 ? 'Lykilorðið þarf að vera a.m.k. 6 stafir að lengd' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                }
              ),

              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.grey[300],
                elevation: 0.0,
                child: Text(
                  'Nýskráning',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    dynamic result = await _auth.signUpWithEmail(email, password);
                    if(result == null) {
                      setState(() => error = 'Netfang fannst ekki');
                    }
                  }
                },
              ),

              SizedBox(height: 12.0),
              Text(
                error,
              ),
            ],
          ),
        )
      ),
    );
  }
}
