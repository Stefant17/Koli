import 'package:flutter/material.dart';
import 'package:koli/models/category.dart';
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

  String newStore = '';
  String newStoreID = '';
  String newDate = Date(DateTime.now()).getCurrentDate();
  String newMCC = '';
  String newRegion = '';
  String newCategory = '';
  String newCategoryID = '';
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

          return StreamBuilder<List<Category>>(
            stream: DatabaseService().categories,
            builder: (context, categorySnapshot) {
              if(categorySnapshot.hasData) {
                List<Category> categories = categorySnapshot.data;

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
                                    validator: (val) => val == null ? 'Veldu fyrirtæki'
                                        : null,
                                    hint: newStore == ''
                                        ? Text('Fyrirtæki')
                                        : Text(newStore),
                                    items: companies.map((com) {
                                      return DropdownMenuItem<Company>(
                                        value: com,
                                        child: Text('${com.name}'),
                                      );
                                    }).toList(),

                                    onChanged: (val) {
                                      setState(() {
                                        newStore = val.name;
                                        newStoreID = val.companyID;
                                        newMCC = val.mccID;
                                        newRegion = val.region;
                                      });
                                    },
                                  ),
                                ),

                                SizedBox(width: 10),

                                Expanded(
                                  child: DropdownButtonFormField<Category>(
                                    validator: (val) => val == null ? 'Veldu vöruflokk'
                                        : null,
                                    hint: newStore == ''
                                        ? Text('Vöruflokkur')
                                        : Text(newCategory),
                                    items: categories.map((cat) {
                                      return DropdownMenuItem<Category>(
                                        value: cat,
                                        child: Text('${cat.name}'),
                                      );
                                    }).toList(),

                                    onChanged: (val) {
                                      setState(() {
                                        newCategoryID = val.catID;
                                        newCategory = val.name;
                                      });
                                    },
                                  ),
                                ),

                                SizedBox(width: 10),

                                Expanded(
                                  child: TextFormField(
                                    validator: (val) =>
                                    val.isEmpty
                                        ? 'Sláðu inn verð'
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
                                if(_formKey.currentState.validate()) {
                                  var newTrans = UserTransaction(
                                    amount: newAmount,
                                    company: newStore,
                                    companyID: newStoreID,
                                    date: newDate,
                                    mcc: newMCC,
                                    region: newRegion,
                                    categoryID: newCategoryID,
                                    category: newCategory,
                                  );

                                  createNewTransaction(
                                      newTrans,
                                      widget.user.uid
                                  );

                                  widget.toggleCreateTransaction(false);
                                  newDate = Date(DateTime.now()).getCurrentDate();
                                }
                              },
                            ),
                          ]
                      ),
                    ),
                  ),
                );
              } else {
                return Card();
              }
            }
          );
        } else {
          return Scaffold();
        }
      }
    );
  }
}
