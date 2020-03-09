import 'package:flutter/material.dart';
import 'package:koli/models/badge.dart';

class BadgeView extends StatelessWidget {
  Badge badge;
  BadgeView({ this.badge });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                '${badge.image}',
                width: 75,
                height: 75,
              ),
              Text('${ badge.name }'),
            ],
          ),
        ]
      )
    );
  }
}
