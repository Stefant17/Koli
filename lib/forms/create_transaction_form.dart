import 'package:flutter/material.dart';
import 'package:koli/models/company.dart';
import 'package:koli/models/date.dart';
import 'package:koli/models/transaction.dart';
import 'package:koli/services/dataService.dart';


class CreateTransactionForm extends StatefulWidget {
  final Function toggleCreateTransaction;
  final user;
  CreateTransactionForm({ this.toggleCreateTransaction, this.user });

  @override
  _CreateTransactionFormState createState() => _CreateTransactionFormState();
}

class _CreateTransactionFormState extends State<CreateTransactionForm> {
  static final _formKey = GlobalKey<FormState>();
  DateTime currentDate = DateTime.now();

  String newCompany = '';
  String newDate = Date(DateTime.now()).getCurrentDate();
  String newMcc = '';
  String newRegion = '';
  int newAmount = 0;

  void createNewTransaction(UserTransaction trans, String uid) async {
    await DatabaseService(uid: uid).createUserTransaction(trans);
  }

  Future<Null> selectDate(BuildContext context) async {
    int nextYear = currentDate.year + 1;
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(nextYear),
    );

    if(picked != null) {
      setState(() {
        newDate = Date(picked).getCurrentDate();
      });
    }
  }

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
                      'Ný færsla',
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
                                newCompany = val.name;
                                newMcc = val.mccID;
                                newRegion = val.region;
                              });
                            },
                          ),
                        ),

                        SizedBox(width: 50),

                        Expanded(
                          child: TextFormField(
                            validator: (val) =>
                            val.isEmpty ? 'Vinsamlegast sláðu inn verð' : null,
                            decoration: InputDecoration(
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

                        IconButton(
                          alignment: Alignment.topRight,
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              widget.toggleCreateTransaction(false);
                            });
                          },
                        ),
                      ],
                    ),

                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
                              selectDate(context);
                            },
                          ),

                          Text(newDate),
                        ],
                      ),
                    ),

                    RaisedButton(
                      elevation: 0.0,
                      color: Colors.black,
                      child: Text(
                        'Staðfesta',
                        style: TextStyle(color: Colors.white),
                      ),

                      onPressed: () async {
                        var newTrans = UserTransaction(
                          amount: newAmount,
                          company: newCompany,
                          date: newDate,
                          mcc: newMcc,
                          region: newRegion,
                        );

                        createNewTransaction(newTrans, widget.user.uid);
                        widget.toggleCreateTransaction(false);
                        newDate = Date(DateTime.now()).getCurrentDate();
                      },
                    ),
                  ]
                ),
              ),
            ),
          );
        } else {
          return Scaffold();
        }
      }
    );
  }
}
