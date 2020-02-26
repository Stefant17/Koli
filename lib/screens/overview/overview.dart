import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/transaction.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/views/transaction_view.dart';
import 'package:provider/provider.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  var constants = Constants();
  var createTransaction = false;

  void editTransaction(UserTransaction trans, String uid) {
    print(trans.transID);
  }

  void addTransaction(String uid) {

  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final _formKey = GlobalKey<FormState> ();

    return StreamBuilder<List<UserTransaction>>(
      stream: DatabaseService(uid: user.uid).userTransactions,
      builder: (context, snapshot) {
        print(snapshot);
        if(snapshot.hasData) {
          List<UserTransaction> userTransactions = snapshot.data;

          return Scaffold(
              backgroundColor: Colors.brown[50],
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
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Fyrirtæki',
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),

                                        onChanged: (val) {
                                          setState(() {
                                            //newStore = val;
                                          });
                                        },
                                      ),
                                    ),

                                    SizedBox(width: 50),

                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Verð',
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),

                                        onChanged: (val) {
                                          setState(() {
                                            //newAmount = int.parse(val);
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

                                RaisedButton(
                                  elevation: 0.0,
                                  color: Colors.black,
                                  child: Text(
                                    'Staðfesta',
                                    style:TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    createTransaction = false;
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
                        SizedBox(height: 20),
                        FloatingActionButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              createTransaction = true;
                            });
                          },
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
