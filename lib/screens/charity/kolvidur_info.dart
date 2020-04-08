import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class KolvidurInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Kolviður',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),

          SizedBox(height: 10),

          Text(
              'Kolviður er sjóður sem hefur það markmið að draga úr styrk '
                  'koldíoxíðs í andrúmsloftinu.'
                  ' Sjóðurinn reiðir á á framlög frá landsmönnum þar sem þeir geta '
                  'gefið tiltekna upphæð til þess að gróðursetja tré hér á landi.'
                  '\n\nVið bjóðum notendum okkar upp á þann möguleika að kolefnisjafna'
                  ' sig með því að styrkja Kolvið og gróðursetja tré í gegnum appið.\n\n'
                  'Öll framlög fara til Kolviðar og munu hafa bein áhrif á kolefnisporið '
                  'þitt í appinu.\n'
          ),

          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Nánari upplýsingar: ',
            ),
          ),

          SizedBox(height: 10),

          Container(
            alignment: Alignment.bottomLeft,
            child: InkWell(
              child: Text(
                  'kolvidur.is',
                  style: TextStyle(
                      color: Colors.blueAccent
                  )
              ),

              onTap: () async {
                if(await canLaunch('https://kolvidur.is/')) {
                  await launch(
                    'https://kolvidur.is/',
                    forceWebView: true,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


