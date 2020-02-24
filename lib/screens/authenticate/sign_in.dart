import 'package:flutter/material.dart';
import 'package:koli/services/authService.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        elevation: 0.0,
        title: Text('Innskráning'),
        actions: <Widget> [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Nýskráning'),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget> [
              SizedBox(height: 20.0),
              TextFormField(
                onChanged: (val) {
                  setState(() => email = val);
                }
              ),

              SizedBox(height: 20.0),
              TextFormField(
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
                  'Innskráning',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  dynamic result = await _auth.signInEmail(email, password);
                  if(result == null) {
                    print('sign in error!');
                  } else {
                    print('user signed in');
                    print(result.uid);
                  }
                },
              ),
            ],
          ),
        )
      ),
    );
  }
}
