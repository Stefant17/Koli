import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:provider/provider.dart';
import 'package:koli/shared/bottom_navbar.dart';

class DietSettings extends StatefulWidget {
  @override
  _DietSettingsState createState() => _DietSettingsState();
}



String tempValues(String value){
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

String meatValues(String newValue, String defaultVal){
  if(newValue == 'aldrei'){
    return '0';
  }else if (newValue == '1 sinni'){
    return '0.05';
  }else if (newValue == '2 sinnum'){
    return '0.09';
  }else if (newValue == '3 sinnum'){
    return '0.15';
  }else if (newValue == '4 sinnum'){
    return '0.20';
  }else if (newValue == 'oftar'){
    return '0.25';
  }else{
    return defaultVal;
  }
}
String fishValues(String newValue, String defaultValue){
  if(newValue == 'aldrei'){
    return '0';
  }else if (newValue == '1 sinni'){
    return '0.5';
  }else if (newValue == '2 sinnum'){
    return '0.9';
  }else if (newValue == '3 sinnum'){
    return '0.15';
  }else if (newValue == '4 sinnum'){
    return '0.20';
  }else if (newValue == 'oftar'){
    return '0.25';
  }else{
    return defaultValue;
  }
}
String fruitValue(String newValue, String defaultVal){
  if(newValue == 'aldrei'){
    return '0.0';
  }else if (newValue == '1 sinni'){
    return '0.5';
  }else if (newValue == '2 sinnum'){
    return '0.10';
  }else if (newValue == '3 sinnum'){
    return '0.15';
  }else if (newValue == '4 sinnum'){
    return '0.20';
  }else if (newValue == 'oftar'){
    return '0.25';
  }else{
    return defaultVal;
  }
}
String dairyValue(String newValue, String defaultVal){
  if(newValue == 'aldrei'){
    return '0.0';
  }else if (newValue == '1 sinni'){
    return '0.05';
  }else if (newValue == '2 sinnum'){
    return '0.10';
  }else if (newValue == '3 sinnum'){
    return '0.15';
  }else if (newValue == '4 sinnum'){
    return '0.20';
  }else if (newValue == 'oftar'){
    return '0.25';
  }else{
    return defaultVal;
  }
}




List<DropdownMenuItem<double>> makeListDouble(List percentages){
  List<DropdownMenuItem<double>> temp= List();
  for(double i in percentages){
    temp.add(new DropdownMenuItem(value: i, child: new Text(i.toString()),));
  }
  return temp;
}

List<DropdownMenuItem<String>>  makeListString(List car){
  List<DropdownMenuItem<String>> temp= List();
  for(String i in car){
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
  List<DropdownMenuItem<String>> _persentagesList = makeListString(_persentages);
  List<DropdownMenuItem<String>> _carTypesList = makeListString(_carTypes);
  List<DropdownMenuItem<String>> _carSizeList = makeListString(_carSizes);
// temp variables that will be submitted when changed
  String newFish = '';
  String newMeat = '';
  String newDairy = '';
  String newFruit = '';
  String newAge = '';
  String newFirstName = '';
  String newLastName = '';
  String newCarFuelType = '';
  String newCarSize = '';
  String carFuelType = '';
  String carSize = '';
  String newUsername = '';
// breyts values frá userdata í "1 sinni" "2 sinnum" svo það virki með dropdownlist
  String tempFish ;
  String tempMeat ;
  String tempDairy;
  String tempFruit;
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
                tempFish = tempValues(userData.fish);
                tempMeat = tempValues(userData.meat);
                tempDairy = tempValues(userData.dairy);
                tempFruit = tempValues(userData.fruit);
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
                              newFirstName = str;
                            });},
                           ),),
                         Expanded(child:TextField(
                            decoration: new InputDecoration(
                            hintText: "Last name",),
                            onChanged: (String str) {
                            setState(() {
                              newFirstName = str;
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
                            value: newMeat != ''? newMeat: tempMeat,
                            items: _persentagesList,
                            onChanged: (newPersentage) {
                              setState(() {
                                newMeat = newPersentage;
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
                          value: newFish != ''? newFish:  tempFish,
                          items: _persentagesList,
                          onChanged: (newPersentage) {
                            setState(() {
                              newFish = newPersentage;
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
                        value: newFruit != ''? newFruit:  tempFruit,
                        items: _persentagesList,
                        onChanged: (newPersentage) {
                          setState(() {
                            newFruit = newPersentage;
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
                        value: newDairy != ''? newDairy: tempDairy,
                        items: _persentagesList,
                        onChanged: (newPersentage) {
                          setState(() {
                            newDairy = newPersentage;
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
                      value:  newCarFuelType != ''? newCarFuelType: userData.carFuelType,
                      items: _carTypesList ,
                      onChanged: (newValue){
                        setState(() {
                          newCarFuelType = newValue;
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
                      value:  newCarSize != ''? newCarSize: userData.carSize,
                      items: _carSizeList ,
                      onChanged: (newValue){
                          setState(() {
                            newCarSize = newValue;
                          });
                      },
                    ),),
              ]),
                    RaisedButton(
                      child: Text('Staðfesta?'),
                      onPressed: (){
                        if(newFirstName == ''){
                          newFirstName = userData.firstName;
                        }
                        if(newLastName == ''){
                          newLastName = userData.lastName;
                        }
                        if(newMeat == ''){
                          newMeat = userData.meat;
                        }else{
                          newMeat = meatValues(newMeat, userData.meat);
                        }
                        if(newFish == '') {
                          newFish = userData.fish;
                        }else{
                          newFish = fishValues(newFish, userData.fish);
                        }
                        if(newDairy == ''){
                          newDairy = userData.dairy;
                        }else{
                          newDairy = dairyValue(newDairy, userData.dairy);
                        }
                        if(newFruit == ''){
                          newFruit = userData.fruit;
                        }else{
                          newFruit = fruitValue(newFruit, userData.fruit);
                        }
                        if(newCarFuelType == ''){
                          newCarFuelType = userData.carFuelType;
                        }
                        if(newCarSize == ''){
                          newCarSize = userData.carSize;
                        }
                        if(newUsername == ''){
                          newUsername = userData.username;
                        }
                          DatabaseService(uid: user.uid).updateUserProfile(newFirstName, newLastName, userData.age, newMeat, newFish, newDairy, newFruit, newCarFuelType, newCarSize, userData.treesPlanted, userData.username, userData.daysActive);
                        newFish = '';
                        newMeat = '';
                        newDairy = '';
                        newFruit = '';
                        newAge = '';
                        newFirstName = '';
                        newLastName = '';
                        newCarFuelType = '';
                        newCarSize = '';
                        carFuelType = '';
                        carSize = '';
                        newUsername = '';
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
      floatingActionButton: HomeFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}