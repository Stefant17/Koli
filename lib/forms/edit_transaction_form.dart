import 'package:flutter/material.dart';
import 'package:koli/models/company.dart';
import 'package:koli/models/transaction.dart';
import 'package:koli/services/dataService.dart';

class EditTransactionForm extends StatefulWidget {
  final Function toggleEditTrans;
  final Function editTransaction;
  final userTransaction;
  EditTransactionForm({ this.toggleEditTrans, this.editTransaction, this.userTransaction });

  @override
  _EditTransactionFormState createState() => _EditTransactionFormState();
}

class _EditTransactionFormState extends State<EditTransactionForm> {
  final _formKey = GlobalKey<FormState>();

  String newStore = ''; //widget.userTransaction.company;
  String newMCC = '';
  String newRegion = '';
  int newAmount = 0;

  @override
  Widget build(BuildContext context) {
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
                            hint: newStore == '' ? Text('Fyrirtæki') : Text(newStore),
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
                              widget.toggleEditTrans(false);
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

                          widget.editTransaction(updatedTrans, widget.userTransaction.transID);
                          widget.toggleEditTrans(false);
                        },
                      ),
                    ),
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
