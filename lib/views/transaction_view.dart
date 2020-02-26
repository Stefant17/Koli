import 'package:flutter/material.dart';
import 'package:koli/models/transaction.dart';

class TransactionView extends StatefulWidget {
  final UserTransaction userTransaction;
  final String uid;
  final Function editTransaction;
  TransactionView({ this.userTransaction, this.uid, this.editTransaction });

  @override
  _TransactionViewState createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  final _formKey = GlobalKey<FormState> ();

  bool editTrans = false;
  String newStore = '';
  int newAmount = 0;

  @override
  Widget build(BuildContext context) {
    if(!editTrans) {
      return Card(
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 1.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      widget.userTransaction.company,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(width: 80),

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

                Text(
                  '${widget.userTransaction.date}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[800],
                  ),
                ),

                SizedBox(height: 8.0),
              ],
            ),
          )
      );
    } else {
      return Card(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 1.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: widget.userTransaction.company,
                          fillColor: Colors.white,
                          filled: true,
                        ),

                        onChanged: (val) {
                          setState(() {
                            newStore = val;
                          });
                        },
                      ),
                    ),

                    SizedBox(width: 80),

                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '${widget.userTransaction.amount}',
                          fillColor: Colors.white,
                          filled: true,
                        ),

                        onChanged: (val) {
                          setState(() {
                            newAmount = int.parse(val);
                          });
                        },
                      ),
                    ),

                    IconButton(
                      alignment: Alignment.topRight,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          editTrans = false;
                        });
                      },
                    ),
                  ],
                ),

                RaisedButton(
                  elevation: 0.0,
                  color: Colors.black,
                  child: Text(
                    'Staðfesta',
                    style:TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    UserTransaction updatedTrans = widget.userTransaction;
                    updatedTrans.company = newStore;
                    updatedTrans.amount = newAmount;

                    widget.editTransaction(updatedTrans, widget.uid);
                    editTrans = false;
                  },
                ),

                SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      );
    }
  }
}
