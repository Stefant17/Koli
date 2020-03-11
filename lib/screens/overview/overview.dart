import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/forms/create_transaction_form.dart';
import 'package:koli/models/transaction.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/views/transaction_view.dart';
import 'package:provider/provider.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

/////////////////////////////VALIDATE

class _OverviewState extends State<Overview> {
  var constants = Constants();
  bool createTransaction = false;

  void toggleCreateTransaction(bool state) {
    setState(() {
      createTransaction = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<List<UserTransaction>>(
      stream: DatabaseService(uid: user.uid).userTransactions,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          List<UserTransaction> userTransactions = snapshot.data;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar(context),
            body: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Column(
                      children: userTransactions.map((trans) => TransactionView(
                        userTransaction: trans,
                        uid: user.uid,
                      )).toList(),
                    ),

                    createTransaction ? CreateTransactionForm(
                        toggleCreateTransaction: this.toggleCreateTransaction,
                        user: user
                    )
                    :
                    Column(
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            elevation: 0.0,
                            color: Colors.black,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),

                            onPressed: () {
                              setState(() {
                                createTransaction = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            bottomNavigationBar: BottomBar(),
          );
        } else {
          return Scaffold();
        }
      }
    ); //Scaffold
  }
}
