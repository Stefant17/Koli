import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';

class Education extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Fræðsla'),

      body: Container(
        padding: EdgeInsets.all(30),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hvað er kolefnisspor?',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              )
            ),

            SizedBox(height: 10),

            Text(
              'Kolefnisspor er skilgreint sem heildarlosun gróðurhúsalofttegunda'
              ' einstaklings, fyrirtækis, viðburðar eða vöru. Þessar lofttegundir geta'
              ' losnað við brennslu eldsneytis, neyslu matvara og annara vara.'
              '\nHelstu gróðurhúsalofttegundirnar eru Koltvísýringur og Metan.'
            ),

            SizedBox(height: 20),

            Text(
              'Hvað þýðir það að kolefnisjafna sig?',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              )
            ),

            SizedBox(height: 10),

            Text(
              'Það að kolefnisjafna sig er að taka ráðstafanir til þess að'
              ' draga úr kolefnissporinu sínu. '
            ),

            SizedBox(height: 20),

            Text(
                'Hvernig get ég kolefnisjafnað mig?',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )
            ),

            SizedBox(height: 10),

            Text(
              'Einföldustu leiðirnar til þess að draga úr kolefnissporinu sínu'
              ' eru að borða minna kjöt og hjóla eða nýta almenningssamgöngur'
              ' frekar en einkabíl.'
              ' Auk þess er hægt að styðja alls kyns málefni sem eiga sér það'
              ' markmið að draga úr losun gróðurhúsalofttegunda t.d. með því að'
              ' gróðursetja tré.'
            ),
          ],
        ),
      ),

      floatingActionButton: HomeFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBar(),
    );
  }
}
