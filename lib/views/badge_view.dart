import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/models/badge.dart';
import 'package:share/share.dart';

class BadgeView extends StatelessWidget {
  Badge badge;
  BadgeView({ this.badge });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 120,
        width: 110,
        //padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              '${badge.image}',
              width: 75,
              height: 75,
            ),

            Expanded(
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  '${ badge.name }',
                  softWrap: true,
                ),
              )
            ),
          ],
        )
      ),

      onTap: () {
        showDialog(
          context: context,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              width: 100,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${ badge.name }',
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    )
                  ),

                  SizedBox(height: 20),

                  Image.asset(
                    '${badge.image}',
                    width: 100,
                    height: 100,
                  ),

                  SizedBox(height: 20),

                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Skilyrði: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  Text(
                    '${badge.description}',
                  ),

                  SizedBox(height: 10),

                  Text(
                    '${badge.dateEarned}',
                    style: TextStyle(
                      color: Colors.grey[300],
                    )
                  ),

                  InkWell(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        FontAwesomeIcons.shareAlt,
                      )
                    ),

                    onTap: () {
                      Share.share(
                        'Ég var að vinna ${badge.name} orðuna í Kola: "${badge.description}!"',
                      );
                    },
                  )
                ],
              ),
            )
          ),
        );
      },
    );
  }
}
