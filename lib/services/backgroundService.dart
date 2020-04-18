import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:koli/models/co2_by_month.dart';
import 'package:koli/services/dataService.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const EVENTS_KEY = "fetch_events";

BackgroundService(){
  BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: 15,  // <-- minutes
      stopOnTerminate: false,
      startOnBoot: true
  ), (String taskId) {
    // This callback is typically fired every 15 minutes while in the background.
    DatabaseService().checkForNewCardTransactions();

   // Stream<CO2ByMonth> kol = DatabaseService().co2ByMonth;
    // kóði þegar að notifications voru í þessum klasa. óvist hvort hann verið aftur hér eða ekki
    /*if (kol != DatabaseService().co2ByMonth){
      _showNotification();
      print('showing notification');
    }else{
      print('not showing notificaion');
    }*/

    // IMPORTANT:  You must signal completion of your fetch task or the OS could
    // punish your app for spending much time in the background.
    BackgroundFetch.finish(taskId);
  });

}