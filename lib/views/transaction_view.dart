import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      return Container(
        margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15),

                    child: Icon(
                      widget.userTransaction.category == 'Bensín' ? FontAwesomeIcons.gasPump
                      : widget.userTransaction.category == 'Matvörur' ? FontAwesomeIcons.shoppingBasket
                      : widget.userTransaction.category == 'Fatnaður' ? FontAwesomeIcons.redhat
                      : null,
                      color: Color(0xFFF3F8F2),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: widget.userTransaction.category == 'Bensín' ? Color(0xFFD81E5B)
                          : widget.userTransaction.category == 'Matvörur' ? Color(0xFF339989)
                          : widget.userTransaction.category == 'Fatnaður' ? Color(0xFF736CED)
                          : null,
                    ),
                  ),

                  SizedBox(width: 10),

                  Container(
                      //alignment: Alignment.centerLeft,
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.userTransaction.company,
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                            ),
                          ),

                          Text(
                            '${widget.userTransaction.date}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                  ),

                  /*
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        widget.userTransaction.category,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[600],
                        ),
                      ),
                  ),
                  */
                  Container(
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
                ],
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
