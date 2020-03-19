import 'package:flutter/foundation.dart';

class UserProfile {
  String uid;
  String firstName;
  String lastName;
  String carFuelType;
  String carSize;

  int age;
  int daysActive;
  int treesPlanted;

  bool pendingInvite;

  List<List> foodPrefrences = [
    ['meat',  0.09],
    ['veg', 0.23],
    ['fruit', 0.19],
    ['fisth', 0.05],
    ['grains', 0.28],
    ['dairy', 0.14],
    ['fish', 0.05],
    ['nuts', 0.02]
  ];

  double meat = 9.0;
  double veg = 23;
  double fruit = 19;
  double  fish = 5;
  double grains = 28;
  double dairy = 0.14;
  double nuts =  0.02;


  UserProfile({
    this.uid, this.firstName,
    this.lastName, this.age,
    this.carSize, this.carFuelType,
    this.daysActive, this.treesPlanted,
    this.pendingInvite,
    this.meat = 9.0,

  });

 // void updatevariables(String name, double content) async {
 //   if(name == 'meat'){
 //     print(content);
 //     this.meat = content;
 //   }
 // }
}