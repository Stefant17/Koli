import 'dart:async';
import 'package:flutter/material.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:koli/services/dataService.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const EVENTS_KEY = "fetch_events";

///Notification variables Start
//notification implemintantion, var í "background Services en þarf að vera hérna vegna þess að checkið er hér n´shit, gæti breyst í farmtíðinni
FlutterLocalNotificationsPlugin flutterLocalNotifiacionsPlugin = new FlutterLocalNotificationsPlugin();
var initializeSettingsAndroid;

// implementaði ekki fyrir IOS því var að focusa að láta þetta runna á android
// hér er tutorialið ef ég ákvað að halda áfram og implementa fyrir ios tutorial: https://www.youtube.com/watch?v=JBOkTsIN22M&ab_channel=CodingWithChip
var initializeSettingsIOS;
var initializeSettings;
///Notification variables END

class BackgroundService {
  BackgroundService() {
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,  // <-- minutes
        stopOnTerminate: false,
        startOnBoot: true
      ), (String taskId) async {

        // This callback is typically fired every 15 minutes while in the background.
        await DatabaseService().checkForNewCardTransactions();

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
      }
    ); ///Notifiaction implementation
  }  ///


  Future onSelectNotification(String payload) async {
    if (payload != null){
      debugPrint('notifications payload  $payload');
    }
  }

  Future<void> _demoNotification() async {
    // icon sem kemur upp þegar að maður fær notification , getum breytt það í að vera icon fyrir appið eða me_koli
    initializeSettingsAndroid = new AndroidInitializationSettings('app_icon');
    initializeSettings = new InitializationSettings(
        initializeSettingsAndroid, initializeSettingsIOS);
    flutterLocalNotifiacionsPlugin.initialize(initializeSettings,
        onSelectNotification: onSelectNotification);
    var androidChannel = AndroidNotificationDetails(
        'channel_ID', 'Channel_name', 'child_description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'test ticker');
    var IOS = IOSNotificationDetails();
    var platformChannelSpecfisics = NotificationDetails(
        androidChannel, IOS);
    await flutterLocalNotifiacionsPlugin.show(
        0, 'test, hello', 'Þú varst að versla við fyrirtæki sem er að kolefnisjafna sig!',
        platformChannelSpecfisics, payload: 'test payload');
  }


  void showNotification() async {
    await _demoNotification();
  }
}