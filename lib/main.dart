import 'package:flutter/material.dart';
import 'package:koli/forms/add_card_form.dart';
import 'package:koli/forms/edit_transaction_form.dart';
import 'package:koli/screens/charity/charity.dart';
import 'package:koli/screens/charity/donation_confirmation.dart';
import 'package:koli/screens/companies/companies.dart';
import 'package:koli/screens/transactions/create_transaction.dart';
import 'package:koli/models/user.dart';
import 'package:koli/screens/badges/badges.dart';
import 'package:koli/screens/transactions/transactions_wrapper.dart';
import 'package:koli/screens/profile/diet_settings.dart';
import 'package:koli/screens/profile/meKoli_settings.dart';
import 'package:koli/screens/profile/profile.dart';
import 'package:koli/screens/statistics/statistics.dart';
import 'package:koli/screens/wrapper.dart';
import 'package:koli/services/authService.dart';
import 'package:provider/provider.dart';
import 'package:koli/services/backgroundService.dart';

void main() {
  runApp(MyApp());
  BackgroundService();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        //home: Wrapper(),
        routes: {
          '/': (context) => Wrapper(),
          '/Færslur': (context) => TransactionWrapper(),
          '/Tölfræði': (context) => Statistics(),
          '/Orður': (context) => Badges(),
          //'/Góðgerðarmál': (context) => CharityScreen(),
          '/Kolefnisjöfnun': (context) => CharityScreen(),
          '/Fyrirtæki': (context) => Companies(),
          '/Prófíll': (context) => Profile(),
          '/Mataræði stillingar': (context) => DietSettings(),
          '/meKoli stillingar': (context) => MeKoliSettings(),
          '/Ný færsla': (context) => CreateTransaction(),
          '/Breyta færslu': (context) => EditTransactionForm(),
          '/Nýtt kort': (context) => AddCardForm(),
          '/Staðfesta framlag': (context) => DonationConfirmation(),
        },
      ),
    );
  }
}