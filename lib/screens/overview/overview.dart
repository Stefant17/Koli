import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/forms/create_transaction_form.dart';
import 'package:koli/models/date.dart';
import 'package:koli/models/transaction.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/views/transaction_view.dart';
import 'package:provider/provider.dart';
import 'package:calendar_time/calendar_time.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

/////////////////////////////VALIDATE

class _OverviewState extends State<Overview> {
  var constants = Constants();
  bool createTransaction = false;

  void toggleCreateTransaction(bool state) {
    setState(() {
      createTransaction = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<List<UserTransaction>>(
      stream: DatabaseService(uid: user.uid).userTransactions,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          List<UserTransaction> userTransactions = snapshot.data;
          List<UserTransaction> todayTransactions = [];
          List<UserTransaction> yesterdayTransactions = [];
          List<UserTransaction> olderTransactions = [];

          for(var i = 0; i < userTransactions.length; i++) {
            var date = DatabaseService().convertToDateTimeFormat(userTransactions[i].date);
            var calendarDate = CalendarTime(DateTime.now());

            if(calendarDate.startOfToday().toString() == date + '0') {
              userTransactions[i].date = Date(DateTime.parse(date)).getDayAndMonth();
              todayTransactions.add(userTransactions[i]);
            }

            else if(calendarDate.startOfYesterday().toString() == date + '0') {
              userTransactions[i].date = Date(DateTime.parse(date)).getDayAndMonth();
              yesterdayTransactions.add(userTransactions[i]);
            }

            else {
              olderTransactions.add(userTransactions[i]);
            }
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar(context),
            body: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(40, 30, 0, 10),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Í dag',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),

                    Column(
                      children: todayTransactions.map((trans) => TransactionView(
                        userTransaction: trans,
                        uid: user.uid,
                      )).toList(),
                    ),

                    SizedBox(height: 10),

                    Container(
                      padding: EdgeInsets.fromLTRB(40, 30, 0, 10),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Í gær',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),

                    Column(
                      children: yesterdayTransactions.map((trans) => TransactionView(
                        userTransaction: trans,
                        uid: user.uid,
                      )).toList(),
                    ),

                    SizedBox(height: 10),

                    Container(
                      padding: EdgeInsets.fromLTRB(40, 30, 0, 10),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Eldra',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Column(
                      children: olderTransactions.map((trans) => TransactionView(
                        userTransaction: trans,
                        uid: user.uid,
                      )).toList(),
                    ),

                    createTransaction ? CreateTransactionForm(
                        toggleCreateTransaction: this.toggleCreateTransaction,
                        user: user
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

            bottomNavigationBar: BottomBar(),
          );
        } else {
          return Scaffold();
        }
      }
    ); //Scaffold
  }
}
