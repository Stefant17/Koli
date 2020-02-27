import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/date.dart';
import 'package:koli/models/transaction.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
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

  int newAmount = 0;
  String newCompany = '';
  String newDate = Date(DateTime.now()).getCurrentDate();
  String newMcc = '';
  String newRegion = '';

  void editTransaction(UserTransaction trans, String transID, String uid) {
    print(trans.transID);
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

      print(newDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<List<UserTransaction>>(
      stream: DatabaseService(uid: user.uid).userTransactions,
      builder: (context, snapshot) {
        print(snapshot);
        if(snapshot.hasData) {
          List<UserTransaction> userTransactions = snapshot.data;

          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                // title: Text('Koli'),
                // centerTitle: true,
                backgroundColor: Colors.grey[400],
                elevation: 0.0,
                automaticallyImplyLeading: false,

                // Dropdown list, user profile
                actions: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 270.0, 0.0),
                    alignment: Alignment.topLeft,
                    child: PopupMenuButton(
                      onSelected: (String choice) {
                        Navigator.pushNamed(context, '/' + choice);
                      },

                      icon: Icon(Icons.menu),
                      itemBuilder: (BuildContext context) {
                        return constants.menuList.map((String item) {
                          return PopupMenuItem<String> (
                            value: item,
                            child: Text('$item'),
                          );
                        }).toList();
                      },
                    ),
                  ),

                  FlatButton.icon(
                    icon: Icon(Icons.face),
                    label: Text(''),
                    onPressed: () {

                    },
                  ),
                ],
              ), //AppBar

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
                    Card(
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
                                      child: TextFormField(
                                        validator: (val) => val.isEmpty ? 'Vinsamlegast veldu fyrirtæki' : null,
                                        decoration: InputDecoration(
                                          labelText: 'Fyrirtæki',
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),

                                        onChanged: (val) {
                                          setState(() {
                                            newCompany = val;
                                          });
                                        },
                                      ),
                                    ),

                                    SizedBox(width: 50),

                                    Expanded(
                                      child: TextFormField(
                                        validator: (val) => val.isEmpty ? 'Vinsamlegast sláðu inn verð' : null,
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
                                    style:TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    var newTrans = UserTransaction(
                                      amount: newAmount,
                                      company: newCompany,
                                      date: newDate,
                                      mcc: newMcc,
                                      region: newRegion,
                                    );
                                    createNewTransaction(newTrans, user.uid);
                                    createTransaction = false;
                                    newDate = Date(DateTime.now()).getCurrentDate();
                                  },
                                ),

                              ]
                          ),
                        ),

                      ),
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
