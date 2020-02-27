import 'package:flutter/material.dart';
import 'package:koli/models/company.dart';
import 'package:koli/models/transaction.dart';
import 'package:koli/services/dataService.dart';

class TransactionView extends StatefulWidget {
  final UserTransaction userTransaction;
  final Function editTransaction;
  final String uid;
  TransactionView({ this.userTransaction, this.uid, this.editTransaction });

  @override
  _TransactionViewState createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  final _formKey = GlobalKey<FormState>();

  bool editTrans = false;
  String newStore = ''; //widget.userTransaction.company;
  String newMCC = '';
  String newRegion = '';
  int newAmount = 0;

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
                    Text(
                      widget.userTransaction.company,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[600],
                      ),
                    ),

                    //SizedBox(width: 80),
  
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
      return StreamBuilder<List<Company>>(
        stream: DatabaseService().companies,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<Company> companies = snapshot.data;

            return Card(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 1.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                          'Breyta færslu',
                          style: (
                              TextStyle(
                                fontSize: 25,
                              )
                          )
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: DropdownButtonFormField<Company>(
                              hint: Text('Fyrirtæki'),
                              //value: newStore,
                              items: companies.map((com) {
                                return DropdownMenuItem<Company>(
                                  value: com,
                                  child: Text('${com.name}'),
                                );
                              }).toList(),

                              onChanged: (val) {
                                setState(() {
                                  newStore = val.name;
                                  newMCC = val.mccID;
                                  newRegion = val.region;
                                });
                              },
                            ),
                          ),

                          SizedBox(width: 80),

                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: '${widget.userTransaction.amount}',
                                labelText: 'Verð',
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

                          Text('kr.'),

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

                      SizedBox(
                        width: 10,
                        child: RaisedButton(
                          elevation: 0.0,
                          color: Colors.black,
                          child: Text(
                            'Staðfesta',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            UserTransaction updatedTrans = widget.userTransaction;
                            if (newAmount == null || newAmount == 0) {
                              newAmount = updatedTrans.amount;
                            }

                            updatedTrans.company = newStore;
                            updatedTrans.amount = newAmount;
                            updatedTrans.mcc = newMCC;
                            updatedTrans.region = newRegion;

                            widget.editTransaction(updatedTrans, widget.userTransaction.transID, widget.uid);
                            editTrans = false;
                          },
                        ),
                      ),
                      //SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Card();
          }
        }
      );
    }
  }
}
