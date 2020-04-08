import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:provider/provider.dart';

class AddCardForm extends StatefulWidget {
  @override
  _AddCardFormState createState() => _AddCardFormState();
}

class _AddCardFormState extends State<AddCardForm> {
  String cardNumber = '';
  String cardExpiry = '';
  String cardCVV = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: appBar(context, 'Nýtt kort'),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Kortanúmer',
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                  ),
                ),
              ),

              validator: (val) =>
              val.isEmpty
                  ? 'Sláðu inn verð'
                  : null,

              keyboardType: TextInputType.number,
              style: TextStyle(
                fontFamily: 'Poppins',
              ),

              inputFormatters: [
                LengthLimitingTextInputFormatter(19),
              ],

              onChanged: (val) {
                if(cardNumber.length <= 18) {
                  if(cardNumber.length == 4 || cardNumber.length == 8 || cardNumber.length == 12) {
                    setState(() {
                      cardNumber += '-';
                    });
                  }

                  setState(() {
                    cardNumber = val;
                  });
                }
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
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
