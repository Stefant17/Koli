import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/category.dart';
import 'package:koli/models/company.dart';
import 'package:koli/models/date.dart';
import 'package:koli/models/transaction.dart';
import 'package:koli/models/user.dart';
import 'package:koli/screens/transactions/transactions_wrapper.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/shared/slide_page_transition.dart';
import 'package:provider/provider.dart';

class EditTransactionForm extends StatefulWidget {
  final trans;

  EditTransactionForm({ this.trans });

  @override
  _EditTransactionFormState createState() => _EditTransactionFormState();
}

class _EditTransactionFormState extends State<EditTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime currentDate = DateTime.now();

  String newStore = '';
  String newStoreID = '';
  String newMCC = '';
  String newRegion = '';
  String newDate = '';
  int newAmount = 0;
  String newCategory = '';
  String newCategoryID = '';

  Widget suggestionRow(String name) {
    return Container(
      width: 50,
      padding: EdgeInsets.fromLTRB(30, 15, 55, 15),
      child: Text(
        name,
      ),
    );
  }

  Future<Null> selectDate(BuildContext context) async {
    int nextYear = currentDate.year + 1;
    final DateTime picked = await showRoundedDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(nextYear),
      borderRadius: 25,
      theme: ThemeData.dark(),
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
        GlobalKey<AutoCompleteTextFieldState<Company>> key = new GlobalKey();
        AutoCompleteTextField<Company> inputField;

        final userTransaction = widget.trans;

        if (snapshot.hasData) {
          List<Company> companies = snapshot.data;

          return StreamBuilder<List<Category>>(
              stream: DatabaseService().categories,
              builder: (context, categorySnapshot) {
                if (categorySnapshot.hasData) {
                  List<Category> categories = categorySnapshot.data;

                  return Scaffold(
                    appBar: appBar(context, ''),
                    backgroundColor: Colors.white,
                    body: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            child: RaisedButton(
                              elevation: 0.0,
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.arrow_back),
                                  //SizedBox(width: 10),
                                  //Text('Til baka'),
                                ],
                              ),

                              onPressed: () {
                                Navigator.push(
                                  context,
                                  SlidePageTransition(
                                    widget: TransactionWrapper(),
                                    offset: 1,
                                  )
                                );
                              },
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Text(
                                    'Breyta færslu',
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                inputField = AutoCompleteTextField<Company>(
                                  key: key,
                                  clearOnSubmit: false,
                                  suggestions: companies,
                                  decoration: InputDecoration(
                                    labelText: newStore == '' ? userTransaction
                                        .company : newStore,
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                      ),
                                    ),
                                  ),

                                  itemFilter: (item, query) {
                                    return item.name.toLowerCase()
                                        .startsWith(query.toLowerCase());
                                  },

                                  itemSorter: (a, b) {
                                    return a.name.compareTo(b.name);
                                  },

                                  itemSubmitted: (item) {
                                    inputField.textField.controller.text =
                                        item.name;
                                    newStore = item.name;
                                    newStoreID = item.companyID;
                                    newMCC = item.mccID;
                                    newRegion = item.region;
                                  },

                                  itemBuilder: (context, item) {
                                    return suggestionRow(item.name);
                                  },

                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Container(
                          padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: '${userTransaction.amount}',
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                      ),
                                    ),
                                  ),

                                  validator: (val) =>
                                  val.isEmpty
                                      ? 'Sláðu inn verð'
                                      : null,

                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),

                                  onChanged: (val) {
                                    setState(() {
                                      newAmount = int.parse(val);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 5),
                              Text('kr.'),

                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Column(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.calendarDay,
                                        //Icons.calendar_today,
                                        size: 35,
                                      ),
                                      onPressed: () {
                                        selectDate(context);
                                      },
                                    ),

                                    Text(newDate != '' ? newDate : userTransaction.date),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        Text(
                          'Vöruflokkur',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),

                        SizedBox(height: 10),

                        Container(
                          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                          height: 75,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: categories.map((cat) {
                              return Column(
                                children: <Widget>[
                                  InkWell(
                                    //elevation: 0,
                                    //color: Colors.white,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      padding: EdgeInsets.all(15),
                                      child: Icon(
                                        Constants().categoryIcons[cat
                                            .name]['Icon'],
                                        color: Colors.white,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Color(
                                            Constants().categoryIcons[cat
                                                .name]['Color']),
                                        border: newCategory == cat.name ? Border
                                            .all(
                                            color: Colors.blueAccent,
                                            width: 2
                                        ) : Border(),
                                      ),
                                    ),

                                    onTap: () {
                                      setState(() {
                                        newCategory = cat.name;
                                        newCategoryID = cat.catID;
                                      });
                                    },
                                  ),

                                  Text(cat.name),
                                ],
                              );
                            }).toList(),
                          ),
                        ),

                        SizedBox(height: 20),

                        RaisedButton(
                          elevation: 0.0,
                          color: Colors.white,
                          child: Text(
                            'Staðfesta',
                            style: TextStyle(color: Colors.black),
                          ),

                          padding: EdgeInsets.fromLTRB(40, 15, 40, 15),

                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              side: BorderSide(
                                color: Colors.black,
                                width: 2,
                              )
                          ),
                          onPressed: () async {
                            UserTransaction updatedTrans = userTransaction;
                            print(updatedTrans.companyID);

                            if (newAmount == null || newAmount == 0) {
                              newAmount = updatedTrans.amount;
                            }

                            if (newStore == null || newStore == '') {
                              newStore = updatedTrans.company;
                            }

                            if (newStoreID == null || newStoreID == '') {
                              newStoreID = updatedTrans.companyID;
                            }

                            if (newDate == null || newDate == '') {
                              newDate = updatedTrans.date;
                            }

                            if (newRegion == null || newRegion == '') {
                              newRegion = updatedTrans.region;
                            }

                            if (newCategoryID == null || newCategoryID == '') {
                              newCategoryID = updatedTrans.categoryID;
                              newCategory = updatedTrans.category;
                            }

                            if (newMCC == null || newMCC == '') {
                              newMCC = updatedTrans.mcc;
                            }

                            updatedTrans.company = newStore;
                            updatedTrans.companyID = newStoreID;
                            updatedTrans.amount = newAmount;
                            updatedTrans.mcc = newMCC;
                            updatedTrans.region = newRegion;
                            updatedTrans.date = newDate;
                            updatedTrans.categoryID = newCategoryID;
                            updatedTrans.category = newCategory;

                            var user = Provider.of<User>(context);

                            DatabaseService(uid: user.uid).editUserTransaction(
                                updatedTrans, userTransaction.transID);
                            //Navigator.pushNamed(context, '/Færslur');

                            Navigator.push(
                                context,
                                SlidePageTransition(
                                  widget: TransactionWrapper(),
                                  offset: 1,
                                )
                            );
                          },
                        ),
                      ],
                    ),

                    bottomNavigationBar: BottomBar(),
                    floatingActionButton: HomeFAB(),
                    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  );
                } else {
                  return Text('yo');
                }
              }
          );
        } else {
          return Text('yo');
        }
      }
    );
  }
}
