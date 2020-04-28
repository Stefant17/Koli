import 'package:flutter/material.dart';
import 'package:koli/services/authService.dart';
import 'package:koli/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if(!loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.0,
          title: Text(
            'Innskráning',
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
                'Nýskráning',
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
                  keyboardType: TextInputType.emailAddress,
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
                    'Innskráning',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()) {
                      setState(() => loading = true);

                      dynamic result = await _auth.signInWithEmail(email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Villa kom upp við innskráningu. \nErtu viss um að netfang og lykilorð sé rétt?';
                          loading = false;
                        });
                      }
                    }
                  },
                ),

                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red), textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ),
      );
    } else {
      return Loading();
    }
  }
}
