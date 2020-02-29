import 'package:flutter/material.dart';
import 'package:koli/forms/edit_transaction_form.dart';
import 'package:koli/models/transaction.dart';
import 'package:koli/services/dataService.dart';

class TransactionView extends StatefulWidget {
  final UserTransaction userTransaction;
  final String uid;
  TransactionView({ this.userTransaction, this.uid });

  @override
  _TransactionViewState createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  bool editTrans = false;

  void editTransaction(UserTransaction trans, String transID) {
    DatabaseService(uid: widget.uid).editUserTransaction(trans, transID);
  }

  void toggleEditTrans(bool state) {
    setState(() {
      editTrans = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!editTrans) {
      return Card(
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.userTransaction.company,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),

                    //SizedBox(width: 100),

                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.userTransaction.category,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
  
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${widget.userTransaction.amount} kr.',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey[800],
                              ),
                            ),

                            IconButton(
                              alignment: Alignment.topRight,
                              icon: Icon(Icons.mode_edit),
                              onPressed: () {
                                setState(() {
                                  editTrans = true;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Text(
                  '${widget.userTransaction.date}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[800],
                  ),
                ),

                //SizedBox(height: 8.0),
              ],
            ),
          )
      );
    } else {
      //return AlertDialog(
          //content:
          return EditTransactionForm(
            toggleEditTrans: this.toggleEditTrans,
            editTransaction: this.editTransaction,
            userTransaction: widget.userTransaction
          );
      //);
    }
  }
}
