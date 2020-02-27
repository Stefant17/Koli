import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/company.dart';
import 'package:koli/models/date.dart';
import 'package:koli/models/transaction.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/views/transaction_view.dart';
import 'package:provider/provider.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

/////////////////////////////VALIDATE

class _OverviewState extends State<Overview> {
  static final _formKey = GlobalKey<FormState> ();
  DateTime currentDate = DateTime.now();
  var constants = Constants();
  bool createTransaction = false;

  String newCompany = '';
  String newDate = Date(DateTime.now()).getCurrentDate();
  String newMcc = '';
  String newRegion = '';
  int newAmount = 0;

  void editTransaction(UserTransaction trans, String transID, String uid) {
    DatabaseService(uid: uid).editUserTransaction(trans, transID);
  }

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
                        editTransaction: this.editTransaction,
                      )).toList(),
                    ),

                    createTransaction ?
                    StreamBuilder<List<Company>>(
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
                                    crossAxisAlignment: CrossAxisAlignment
                                        .stretch,
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
                                            child: DropdownButtonFormField<
                                                Company>(
                                              hint: Text('Fyrirtæki'),
                                              //value: newStore,
                                              items: companies.map((com) {
                                                return DropdownMenuItem<
                                                    Company>(
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
                                              val.isEmpty
                                                  ? 'Vinsamlegast sláðu inn verð'
                                                  : null,
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
                                                createTransaction = false;
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
                                          createNewTransaction(
                                              newTrans, user.uid);
                                          createTransaction = false;
                                          newDate = Date(DateTime.now())
                                              .getCurrentDate();
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
          );
        } else {
          return Scaffold();
        }
      }
    ); //Scaffold
  }
}
