import 'package:flutter/material.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:provider/provider.dart';

class AddCardForm extends StatelessWidget {
  String cardNumber = '';
  String cardExpiry = '';
  String cardCVV = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Dialog(

      //title: Text('Sláðu inn kortaupplýsingar'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
          TextField(
            onChanged: (val) {
              cardNumber = val;
            },
          ),

          TextField(
            onChanged: (val) {
              cardExpiry = val;
            },
          ),

          TextField(
            onChanged: (val) {
              cardCVV = val;
            },
          ),

          RaisedButton(
            elevation: 0,
            child: Text('Staðfesta'),
            onPressed: () {
              DatabaseService(uid: user.uid).addCardToUser(cardNumber, cardExpiry, cardCVV);
              Navigator.pop(context);
            },
          )
        ]
      ),
    );
  }
}
