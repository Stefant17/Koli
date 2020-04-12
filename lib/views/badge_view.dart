import 'package:flutter/material.dart';
import 'package:koli/models/badge.dart';

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
        print(badge.name);
      },
    );
  }
}
