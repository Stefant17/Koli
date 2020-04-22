import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/transaction.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/views/transaction_view.dart';
import 'package:provider/provider.dart';
import 'package:calendar_time/calendar_time.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

/////////////////////////////VALIDATE

class _TransactionsState extends State<Transactions> {
  var constants = Constants();

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
              //userTransactions[i].date = Date(DateTime.parse(date)).getDayAndMonth();
              todayTransactions.add(userTransactions[i]);
            }

            else if(calendarDate.startOfYesterday().toString() == date + '0') {
              //userTransactions[i].date = Date(DateTime.parse(date)).getDayAndMonth();
              yesterdayTransactions.add(userTransactions[i]);
            }

            else {
              olderTransactions.add(userTransactions[i]);
            }
          }

          return Scaffold(
            backgroundColor: Colors.white,
            //appBar: overviewAppBar(context),
            floatingActionButton: FloatingActionButton(

              backgroundColor: Colors.grey[800],
              child: Icon(
                Icons.add,
              ),

              onPressed: () {
                Navigator.pushNamed(context, '/Ný færsla');
              },
            ),
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

                    todayTransactions.isNotEmpty ?
                    Column(
                      children: todayTransactions.map((trans) => TransactionView(
                        userTransaction: trans,
                        uid: user.uid,
                      )).toList(),
                    ):Text('Engin gögn fundust fyrir daginn í dag'),

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

                    yesterdayTransactions.isNotEmpty ?
                    Column(
                      children: yesterdayTransactions.map((trans) => TransactionView(
                        userTransaction: trans,
                        uid: user.uid,
                      )).toList(),
                    ):Text('Engin gögn fundust fyrir gærdaginn'),

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
