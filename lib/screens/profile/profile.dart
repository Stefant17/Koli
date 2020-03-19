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

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

List<DropdownMenuItem<double>> makelist(List persentages){
  List<DropdownMenuItem<double>> temp= List();
  for(double i in persentages){
    temp.add(new DropdownMenuItem(value: i, child: new Text(i.toString()),));
  }
  return temp;
}

class _ProfileState extends State<Profile> {
  static List<double> _persentages = [0, 5, 9.0, 50, 60, 70, 80, 90, 100];
  List<DropdownMenuItem<double>> _persentagesList = makelist(_persentages);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: appBar(context),
      body: Column(
        children: <Widget>[
          StreamBuilder<UserProfile>(
            stream: DatabaseService(uid: user.uid).userProfile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserProfile userData = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child: Text('hversu mikið kjöt borðaru?'),),
                        Expanded(child: Text("hversu oft borðaru fisk? "),),
                        ]),
                    Row(
                      children: <Widget>[
                         Expanded(child:DropdownButton(
                          //icon : Icon(meatPng.png),
                           // isDense: false,
                            isExpanded: true,
                            value: userData.meat,
                            items: _persentagesList,
                            onChanged: (newPersentage) {
                           // userData.updatevariables('meat', newPersentage);
                          },
                        )),
                        Expanded(child: DropdownButton(
                          //icon : Icon(meatPng.png),
                          isDense: false,
                          isExpanded: true,
                          value: userData.fish,
                          items: _persentagesList,
                          onChanged: (newPersentage) {
                            userData.fish = 20;
                            setState(() {
                              print(userData.fish);
                              userData.fish = newPersentage;
                            });
                          },
                        ),),

                      ],
                    ),
                    Text('hvernig bensín notar bílinn þinn?'),
                    DropdownButton(
                      value:null ,
                      items:null ,
                      onChanged: (new_value){
                        //change to disel, electric og oktan
                      },
                    ),
                    Text("submit? "),
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
