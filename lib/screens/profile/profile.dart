
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: appBar(context),
      body: Column(
        children: <Widget>[
          StreamBuilder<UserProfile>(
              stream: DatabaseService(uid: user.uid).userProfile,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  UserProfile userData = snapshot.data;
                  return Text('${userData.firstName}');


                } else {
                  return Text('No data found');
                }
              }
          ),
        ],
      ),
    );
  }
}




/*

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:provider/provider.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/models/options_variables.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

List<DropdownMenuItem<double>> makelist_double(List persentages){
  List<DropdownMenuItem<double>> temp= List();
  for(double i in persentages){
    temp.add(new DropdownMenuItem(value: i, child: new Text(i.toString()),));
  }
  return temp;
}

List<DropdownMenuItem<String>>  makelist_String(List Car){
  List<DropdownMenuItem<String>> temp= List();
  for(String i in Car){
    temp.add(new DropdownMenuItem(value: i, child: Text(i)));
  }
  print(temp);
  return temp;
}

class _ProfileState extends State<Profile> {
  // temp lists that are used
  static List<String> _persentages = ['aldrei', '1 sinni', '2 sinnum', '3 sinnum' , '4 sinnum' 'oftar'];
  static List<String> _carTypes = ['disel', 'oktan', 'elextric'];
  static List<String> _carSizes = ['small', 'medium', 'big'];
  //making the lists into "DropdownMenuItem" so it can be used for dopdownbuttons later
  List<DropdownMenuItem<String>> _persentagesList = makelist_String(_persentages);
  List<DropdownMenuItem<String>> _carTypesList = makelist_String(_carTypes);
  List<DropdownMenuItem<String>> _carSizeList = makelist_String(_carSizes);
// temp variables that will be submitted when changed
  String new_fish = '';
  String new_meat = '';
  String new_dairy = '';
  String new_grain = '';
  String new_age = '';
  String new_FirstName = '';
  String new_LastName = '';
  String new_CarFuelType = '';
  String new_CarSize = '';
  String CarFuelType = '';
  String CarSize = '';
  String new_username = '';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: appBar(context),
      body: ListView(
        children: <Widget>[
          StreamBuilder<UserProfile>(
            stream: DatabaseService(uid: user.uid).userProfile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {/*
                UserProfile userData = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Image(
                        image: AssetImage('assets/images/first_day.png'),
                        width: 125.0,
                        height: 125.0,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                         Expanded( child:TextField(
                         decoration: new InputDecoration(
                           hintText: "First name",),
                           onChanged: (String str) {
                           setState(() {
                              new_FirstName = str;
                            });},
                           ),),
                         Expanded(child:TextField(
                            decoration: new InputDecoration(
                            hintText: "Last name",),
                            onChanged: (String str) {
                            setState(() {
                              new_FirstName = str;
                            });},
                        ),
              )],),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(8.0), child: Text('hversu mikið kjöt borðaru?'),),
                          Padding(padding: EdgeInsets.all(8.0), child: Text("hversu oft borðaru fisk? "),),
                        ]),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child:Container(
                            color: Colors.red,
                            padding: EdgeInsets.all(10.0),
                          child: Image(
                            width: 50.0,
                            height: 50.0,
                            image: AssetImage('assets/images/meatPng.png'),
                          ),
                        ),),
                         Expanded(child:DropdownButton(
                           // isDense: false,
                            isExpanded: true,
                            value: new_meat == ''? new_meat: userData.meat,
                            items: _persentagesList,
                            onChanged: (newPersentage) {
                              setState(() {
                                new_meat = newPersentage;
                              });
                          },
                        )),
                        Expanded(
                          child:Container(
                            color: Colors.blue,
                            padding: EdgeInsets.all(10.0),
                            child: Image(
                              image: AssetImage('assets/images/fish_icon.png'),
                              width: 50.0,
                              height: 50.0,
                            ),
                          ),
                        ),
                        Expanded(child: DropdownButton(
                          isDense: false,
                          isExpanded: true,
                          value: new_fish == ''? new_fish: userData.fish,
                          items: _persentagesList,
                          onChanged: (newPersentage) {
                            setState(() {
                              print(userData.fish);
                              new_fish = newPersentage;
                            });
                          },
                        ),),
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(8.0), child: Text('hversu mikið grain?'),),
                          Padding(padding: EdgeInsets.all(8.0), child: Text("hversu oft borðaru dariy? "),),
                        ]),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:Container(
                          color: Colors.green,
                          padding: EdgeInsets.all(10.0),
                          child: Image(
                            image: AssetImage('assets/images/grain_icon.png'),
                            width: 50.0,
                            height: 50.0,
                          ),
                        ),),
                      Expanded(child:DropdownButton(
                        // isDense: false,
                        isExpanded: true,
                        value: new_grain == ''? new_grain: userData.grains,
                        items: _persentagesList,
                        onChanged: (newPersentage) {
                          setState(() {
                            new_grain = newPersentage;
                          });
                        },
                      )),
                      Expanded(
                        child:Container(
                          color: Colors.yellow,
                          padding: EdgeInsets.all(10.0),
                          child: Image(
                            image: AssetImage('assets/images/dariy_icon.png'),
                            width: 50.0,
                            height: 50.0,
                          ),
                        ),),
                      Expanded(child:DropdownButton(
                        // isDense: false,
                        isExpanded: true,
                        value: new_dairy == ''? new_dairy: userData.dairy,
                        items: _persentagesList,
                        onChanged: (newPersentage) {
                          setState(() {
                            new_dairy = newPersentage;
                          });
                        },
                      )),
                      ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(8.0), child: Text('hvernig bensín notar bílinn þinn?'),),
                          Padding(padding: EdgeInsets.all(8.0), child: Text("hversu stór er bílinn þinn? "),),
                        ]),
                   Row(
                     children: <Widget>[
                       Expanded(
                         child:Container(
                           color: Colors.red,
                           padding: EdgeInsets.all(10.0),
                           child: Image(
                             width: 50.0,
                             height: 50.0,
                             image: AssetImage('assets/images/car_icon.png'),
                           ),
                         ),),
                       //change to disel, electric og oktan
                        Expanded(child:DropdownButton(
                      isExpanded: true,
                      value:  new_CarFuelType,
                      items: _carTypesList ,
                      onChanged: (new_value){
                        setState(() {
                          new_CarFuelType = new_value;
                        });
                      },
                    ),),
                       Expanded(
                         child:Container(
                           color: Colors.red,
                           padding: EdgeInsets.all(10.0),
                           child: Image(
                             width: 50.0,
                             height: 50.0,
                             image: AssetImage('assets/images/fuel_icon.png'),
                           ),
                         ),),
                    // choose how large your car is
                      Expanded(child:DropdownButton(
                        isExpanded: true,
                      value:  new_CarSize,
                      items: _carSizeList ,
                      onChanged: (new_value){
                          setState(() {
                            new_CarSize = new_value;
                          });
                      },
                    ),),
              ]),
                    RaisedButton(
                      child: Text('Staðfesta?'),
                      onPressed: (){
                        if(new_FirstName == ''){
                          new_FirstName = userData.firstName;
                        }
                        if(new_LastName == ''){
                          new_LastName = userData.lastName;
                        }
                        if(new_meat == -1){
                          new_meat = userData.meat;
                        }
                        if(new_fish == -1) {
                          new_fish = userData.fish;
                        }
                        if(new_dairy == -1){
                          new_dairy = userData.dairy;
                        }
                        if(new_grain == -1){
                          new_grain = userData.grains;
                        }
                        if(CarFuelType == ''){
                          CarFuelType = userData.carFuelType;
                        }
                        if(CarSize == ''){
                          CarSize = userData.carSize;
                        }
                        if(new_username == ''){
                          new_username = userData.username;
                        }
                        print(userData.treesPlanted);
                         // DatabaseService(uid: user.uid).updateUserProfile(new_FirstName, new_LastName, userData.age, new_meat, new_fish, new_dairy, new_grain, CarFuelType, CarSize, userData.treesPlanted, userData.username, userData.daysActive);
                      },
                    )
                  ],
                );*/
                return Text('nodatafound');
              }else{
                return Text('No data found');
              }
            }),
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}



*/