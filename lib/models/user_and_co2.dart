import 'package:koli/models/meKoli_avatar.dart';
import 'package:koli/models/user_profile.dart';

class UserAndCO2 {
  UserProfile user;
  MeKoliAvatar avatar;
  int co2ForCurrentMonth;

  UserAndCO2({ this.user, this.avatar, this.co2ForCurrentMonth });
}