import 'package:flutter/material.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/userCard.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:provider/provider.dart';

class DonationConfirmation extends StatefulWidget {
  @override
  _DonationConfirmationState createState() => _DonationConfirmationState();
}

class _DonationConfirmationState extends State<DonationConfirmation> {
  UserCard card;
  int treeAmount;
  int price;

  String donorName;
  String email;

  //DatabaseService(uid: user.uid).plantTrees(treeCount, price, card, donorName)

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final Map arguments = ModalRoute
        .of(context)
        .settings
        .arguments;

    card = arguments['card'];
    treeAmount = arguments['treeAmount'];
    price = arguments['price'];

    return Scaffold(
      appBar: appBar(context, ''),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nafn greiðanda',
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                  ),
                ),
              ),

              validator: (val) =>
              val.isEmpty
                  ? 'Sláðu inn nafn greiðanda'
                  : null,

              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                fontFamily: 'Poppins',
              ),

              onChanged: (val) {
                setState(() {
                  donorName = val;
                });
              },
            ),

            SizedBox(height: 20),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Netfang greiðanda',
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                  ),
                ),
              ),

              validator: (val) =>
              val.isEmpty
                  ? 'Sláðu inn netfang greiðanda'
                  : null,

              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                fontFamily: 'Poppins',
              ),

              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
            ),

            SizedBox(height: 20),

            RaisedButton(
              elevation: 0.0,
              color: Colors.white,
              child: Text(
                'Áfram',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),

              padding: EdgeInsets.fromLTRB(40, 15, 40, 15),

              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                  side: BorderSide(
                    color: Colors.black,
                    width: 2,
                  )
              ),

              onPressed: () {
                DatabaseService(uid: user.uid).plantTrees(
                  treeAmount, price, card, donorName
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
