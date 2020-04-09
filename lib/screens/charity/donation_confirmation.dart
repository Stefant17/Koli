import 'package:flutter/material.dart';
import 'package:koli/models/userCard.dart';

class DonationConfirmation extends StatefulWidget {
  @override
  _DonationConfirmationState createState() => _DonationConfirmationState();
}

class _DonationConfirmationState extends State<DonationConfirmation> {
  UserCard card;
  int treeCount;
  int price;

  String donorName;
  String email;

  //DatabaseService(uid: user.uid).plantTrees(treeCount, price, card, donorName)

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute
        .of(context)
        .settings
        .arguments;

    print(arguments['card'].cardNumber);

    return Text('hello');
  }
}
