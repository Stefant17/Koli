import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:provider/provider.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/models/options_variables.dart';

class DietSettings extends StatefulWidget {
  @override
  _DietSettingsState createState() => _DietSettingsState();
}



String temp_values(String value){
  if (value == null){
    return '';
  }
  double value2 = double.parse(value);
  if (value2 == 0 ){
    return 'aldrei';
  }else if ( value2 <0.06){
    return '1 sinni';
  }else if (value2 < 0.11){
    return '2 sinnum';
  }else if (value2 < 0.16){
    return '3 sinnum';
  }else if (value2 < 0.21){
    return '4 sinnum';
  }else if (value2 < 0.30){
    return 'oftar';
  }else {
    return '';
  }
}

String Meat_value(String new_value, String default_val){
  if(new_value == 'aldrei'){
    return '0';
  }else if (new_value == '1 sinni'){
    return '0.05';
  }else if (new_value == '2 sinnum'){
    return '0.09';
  }else if (new_value == '3 sinnum'){
    return '0.15';
  }else if (new_value == '4 sinnum'){
    return '0.20';
  }else if (new_value == 'oftar'){
    return '0.25';
  }else{
    return default_val;
  }
}
String fish_value(String new_value, String default_val){
  if(new_value == 'aldrei'){
    return '0';
  }else if (new_value == '1 sinni'){
    return '0.5';
  }else if (new_value == '2 sinnum'){
    return '0.9';
  }else if (new_value == '3 sinnum'){
    return '0.15';
  }else if (new_value == '4 sinnum'){
    return '0.20';
  }else if (new_value == 'oftar'){
    return '0.25';
  }else{
    return default_val;
  }
}
String fruit_value(String new_value, String default_val){
  if(new_value == 'aldrei'){
    return '0.0';
  }else if (new_value == '1 sinni'){
    return '0.5';
  }else if (new_value == '2 sinnum'){
    return '0.10';
  }else if (new_value == '3 sinnum'){
    return '0.15';
  }else if (new_value == '4 sinnum'){
    return '0.20';
  }else if (new_value == 'oftar'){
    return '0.25';
  }else{
    return default_val;
  }
}
String dairy_value(String new_value, String default_val){
  if(new_value == 'aldrei'){
    return '0.0';
  }else if (new_value == '1 sinni'){
    return '0.05';
  }else if (new_value == '2 sinnum'){
    return '0.10';
  }else if (new_value == '3 sinnum'){
    return '0.15';
  }else if (new_value == '4 sinnum'){
    return '0.20';
  }else if (new_value == 'oftar'){
    return '0.25';
  }else{
    return default_val;
  }
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
  return temp;
}

class _DietSettingsState extends State<DietSettings> {
  // temp lists that are used
  static List<String> _persentages = ['aldrei', '1 sinni', '2 sinnum', '3 sinnum' , '4 sinnum', 'oftar', ''];
  static List<String> _carTypes = ['disel', "95 Oktan", 'elextric',''];
  static List<String> _carSizes = ['small', 'Medium', 'big',''];
  //making the lists into "DropdownMenuItem" so it can be used for dopdownbuttons later
  List<DropdownMenuItem<String>> _persentagesList = makelist_String(_persentages);
  List<DropdownMenuItem<String>> _carTypesList = makelist_String(_carTypes);
  List<DropdownMenuItem<String>> _carSizeList = makelist_String(_carSizes);
// temp variables that will be submitted when changed
  String new_fish = '';
  String new_meat = '';
  String new_dairy = '';
  String new_fruit = '';
  String new_age = '';
  String new_FirstName = '';
  String new_LastName = '';
  String new_CarFuelType = '';
  String new_CarSize = '';
  String CarFuelType = '';
  String CarSize = '';
  String new_username = '';
// breyts values frá userdata í "1 sinni" "2 sinnum" svo það virki með dropdownlist
  String temp_fish ;
  String temp_meat ;
  String temp_dairy;
  String temp_fruit;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: appBar(context, 'Prófíll'),
      body: ListView(
        children: <Widget>[
          StreamBuilder<UserProfile>(
            stream: DatabaseService(uid: user.uid).userProfile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserProfile userData = snapshot.data;
                temp_fish = temp_values(userData.fish);
                temp_meat = temp_values(userData.meat);
                temp_dairy = temp_values(userData.dairy);
                temp_fruit = temp_values(userData.fruit);
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
                          Padding(padding: EdgeInsets.all(8.0), child: Text(' kjöt á viku?'),),
                          Padding(padding: EdgeInsets.all(8.0), child: Text(" fisk á viku? "),),
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
                            value: new_meat != ''? new_meat: temp_meat,
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
                          value: new_fish != ''? new_fish:  temp_fish,
                          items: _persentagesList,
                          onChanged: (newPersentage) {
                            setState(() {
                              new_fish = newPersentage;
                            });
                          },
                        ),),
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(8.0), child: Text('ávextir á dag?'),),
                          Padding(padding: EdgeInsets.all(8.0), child: Text("mjólkuvörur á dag?"),),
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
                        value: new_fruit != ''? new_fruit:  temp_fruit,
                        items: _persentagesList,
                        onChanged: (newPersentage) {
                          setState(() {
                            new_fruit = newPersentage;
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
                        value: new_dairy != ''? new_dairy: temp_dairy,
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
                      value:  new_CarFuelType != ''? new_CarFuelType: userData.carFuelType,
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
                      value:  new_CarSize != ''? new_CarSize: userData.carSize,
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
                        if(new_meat == ''){
                          new_meat = userData.meat;
                        }else{
                          new_meat = Meat_value(new_meat, userData.meat);
                        }
                        if(new_fish == '') {
                          new_fish = userData.fish;
                        }else{
                          new_fish = fish_value(new_fish, userData.fish);
                        }
                        if(new_dairy == ''){
                          new_dairy = userData.dairy;
                        }else{
                          new_dairy = dairy_value(new_dairy, userData.dairy);
                        }
                        if(new_fruit == ''){
                          new_fruit = userData.fruit;
                        }else{
                          new_fruit = fruit_value(new_fruit, userData.fruit);
                        }
                        if(new_CarFuelType == ''){
                          new_CarFuelType = userData.carFuelType;
                        }
                        if(new_CarSize == ''){
                          new_CarSize = userData.carSize;
                        }
                        if(new_username == ''){
                          new_username = userData.username;
                        }
                          DatabaseService(uid: user.uid).updateUserProfile(new_FirstName, new_LastName, userData.age, new_meat, new_fish, new_dairy, new_fruit, new_CarFuelType, new_CarSize, userData.treesPlanted, userData.username, userData.daysActive);
                        new_fish = '';
                        new_meat = '';
                        new_dairy = '';
                        new_fruit = '';
                        new_age = '';
                        new_FirstName = '';
                        new_LastName = '';
                        new_CarFuelType = '';
                        new_CarSize = '';
                        CarFuelType = '';
                        CarSize = '';
                        new_username = '';
                      },
                    )
                  ],
                );
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