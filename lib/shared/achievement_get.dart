import 'package:flutter/material.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:koli/models/badge.dart';

Widget achievementGet(BuildContext context, Badge badge) {
  AchievementView(
    context,
    title: badge.name,
    subTitle: badge.description,
    isCircle: true,
    icon: Image.asset(badge.image),
    color: Colors.black,
  )..show();
}