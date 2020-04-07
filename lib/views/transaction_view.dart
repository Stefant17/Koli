import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/constants/constants.dart';
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
      return InkWell(
        onTap: () {
          setState(() {
            Navigator.pushNamed(
              context, '/Breyta færslu',
              arguments:  {'trans' :widget.userTransaction}
            );
          });
        },
        child: Container(
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
                        Constants().categoryIcons[widget.userTransaction.category]['Icon'],
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(Constants().categoryIcons[widget.userTransaction.category]['Color']),
                      ),
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.userTransaction.company,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${widget.userTransaction.date}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            ],
                         ),
                      ),
                    ),

                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 40, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${widget.userTransaction.amount} kr.',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            /*
                            IconButton(
                              alignment: Alignment.topRight,
                              icon: Icon(Icons.mode_edit),
                              onPressed: () {
                                setState(() {
                                  editTrans = true;
                                });
                              },
                            ),

                             */
                          ],
                        ),
                    ),
                  ],
                ),
                //SizedBox(height: 8.0),
              ],
            ),
          )
        ),
      );
    } else {
      //return AlertDialog(
          //content:
      return Text('yo');
      //);
    }
  }
}
