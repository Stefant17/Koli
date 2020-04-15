import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:provider/provider.dart';

class MeKoliSettings extends StatefulWidget {
  @override
  _MeKoliSettingsState createState() => _MeKoliSettingsState();
}

class _MeKoliSettingsState extends State<MeKoliSettings> {
  List<String> faces = [
    'assets/images/meKoli/meKoli_face1.PNG',
    'assets/images/meKoli/meKoli_face2.PNG',
    'assets/images/meKoli/meKoli_face3.PNG',
    'assets/images/meKoli/meKoli_face4.PNG',
    'assets/images/meKoli/meKoli_face5.PNG',
    'assets/images/meKoli/meKoli_face6.PNG'
  ];

  List<String> eyes = [
    'assets/images/meKoli/meKoli_eyes.PNG',
    'assets/images/meKoli/meKoli_eyes1.PNG',
    'assets/images/meKoli/meKoli_eyes2.PNG',
    'assets/images/meKoli/meKoli_eyes3.PNG',
    'assets/images/meKoli/meKoli_eyes7.PNG',
    'assets/images/meKoli/meKoli_eyes8.PNG',
    'assets/images/meKoli/meKoli_eyes10.PNG',
    'assets/images/meKoli/meKoli_eyes11.PNG',
    'assets/images/meKoli/meKoli_eyes12.PNG',
    'assets/images/meKoli/meKoli_eyes13.PNG',
    'assets/images/meKoli/meKoli_eyes14.PNG',
    'assets/images/meKoli/meKoli_seyes15.PNG',
  ];

  List<String> eyebrows = [
    'assets/images/meKoli/meKoli_eyebrows.PNG',
    'assets/images/meKoli/meKoli_eyebrows1.PNG',
    'assets/images/meKoli/meKoli_eyebrows2.PNG',
    'assets/images/meKoli/meKoli_eyebrows3.PNG',
    'assets/images/meKoli/meKoli_eyebrows4.PNG',
    'assets/images/meKoli/meKoli_eyebrows5.PNG',
    'assets/images/meKoli/meKoli_eyebrows6.PNG',
  ];

  List<String> beards = [
    'assets/images/meKoli/meKoli_beard1.png',
    'assets/images/meKoli/meKoli_beard2.png',
    'assets/images/meKoli/meKoli_beard3.PNG',
    'assets/images/meKoli/meKoli_beard4.PNG',
    'assets/images/meKoli/meKoli_beard5.PNG',
    'assets/images/meKoli/meKoli_beard6.PNG',
  ];

  List<String> mouths = [
    'assets/images/meKoli/meKoli_mouth1.PNG',
    'assets/images/meKoli/meKoli_mouth2.PNG',
    'assets/images/meKoli/meKoli_mouth3.PNG',
    'assets/images/meKoli/meKoli_mouth4.PNG',
    'assets/images/meKoli/meKoli_mouth5.PNG',
    'assets/images/meKoli/meKoli_mouth6.PNG',
    'assets/images/meKoli/meKoli_mouth7.PNG',
    'assets/images/meKoli/meKoli_mouth8.PNG',
    'assets/images/meKoli/meKoli_mouth9.PNG',
    'assets/images/meKoli/meKoli_mouth10.PNG',
    'assets/images/meKoli/meKoli_mouth11.PNG',
    'assets/images/meKoli/meKoli_mouth12.PNG',
    'assets/images/meKoli/meKoli_mouth14.PNG',
    'assets/images/meKoli/meKoli_mouth15.PNG',
  ];

  int faceIndex = 0;
  int eyeIndex = 0;
  int eyebrowIndex = 0;
  int beardIndex = 0;
  int mouthIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, ''),
      body: Column(
        children: <Widget>[
          Container(
            child: RaisedButton(
              elevation: 0.0,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Icon(Icons.arrow_back),
                  //SizedBox(width: 10),
                  //Text('Til baka'),
                ],
              ),

              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          Container(
            alignment: Alignment.topCenter,
            child: Stack(
              children: <Widget>[
                Image.asset(
                  //'assets/images/meKoli/meKoli_face1.PNG',
                  faces[faceIndex],
                  width: 250,
                  height: 300,
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(50, 50, 0, 0),
                  child: Image.asset(
                    //'assets/images/meKoli/meKoli_eyes11.PNG',
                    eyes[eyeIndex],
                    width: 150,
                    height: 150,
                  ),
                ),

                eyebrowIndex > -1 ? Container(
                  padding: EdgeInsets.fromLTRB(55, 20, 0, 0),
                  child: Image.asset(
                    //'assets/images/meKoli/meKoli_mouth7.PNG',
                    eyebrows[eyebrowIndex],
                    width: 150,
                    height: 150,
                  ),
                ): Container(),

                Container(
                  padding: EdgeInsets.fromLTRB(55, 140, 0, 0),
                  child: Image.asset(
                    mouths[mouthIndex],
                    width: 150,
                    height: 150,
                  ),
                ),

                beardIndex > -1 ? Container(
                  padding: EdgeInsets.fromLTRB(55, 120, 0, 0),
                  child: Image.asset(
                    beards[beardIndex],
                    width: 150,
                    height: 150,
                  ),
                ): Container(),
              ],
            ),
          ),

          RaisedButton(
            elevation: 0.0,
            color: Colors.white,
            child: Text(
              'Staðfesta',
              style: TextStyle(color: Colors.black),
            ),

            padding: EdgeInsets.fromLTRB(40, 15, 40, 15),

            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(25.0),
                side: BorderSide(
                  color: Colors.black,
                  width: 2,
                )
            ),
            onPressed: () async {
              final user = Provider.of<User>(context);
              String beard = '';
              String eyebrow = '';

              if(beardIndex > -1) {
                beard = beards[beardIndex];
              }

              if(eyebrowIndex > -1) {
                eyebrow = eyebrows[eyebrowIndex];
              }

              List<String> meKoli = [
                faces[faceIndex],
                mouths[mouthIndex],
                eyes[eyeIndex],
                beard,
                eyebrow,
              ];

              DatabaseService(uid: user.uid).confirmMeKoli(meKoli);
            }
          ),

          Container(
            height: 100,
            width: 200,
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                          FontAwesome.angle_left
                      ),

                      onTap: () {
                        if(faceIndex > 0) {
                          setState(() {
                            faceIndex--;
                          });
                        }
                      },
                    ),

                    SizedBox(width: 20),

                    Text(
                      'Andlit',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),

                    SizedBox(width: 20),

                    InkWell(
                      child: Icon(
                          FontAwesome.angle_right
                      ),

                      onTap: () {
                        if(faceIndex < faces.length - 1) {
                          setState(() {
                            faceIndex++;
                          });
                        }
                      },
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                          FontAwesome.angle_left
                      ),

                      onTap: () {
                        if(eyeIndex > 0) {
                          setState(() {
                            eyeIndex--;
                          });
                        }
                      },
                    ),

                    SizedBox(width: 20),

                    Text(
                      'Augu',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),

                    SizedBox(width: 20),

                    InkWell(
                      child: Icon(
                          FontAwesome.angle_right
                      ),

                      onTap: () {
                        if(eyeIndex < eyes.length - 1) {
                          setState(() {
                            eyeIndex++;
                          });
                        }
                      },
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                          FontAwesome.angle_left
                      ),

                      onTap: () {
                        if(mouthIndex > 0) {
                          setState(() {
                            mouthIndex--;
                          });
                        }
                      },
                    ),

                    SizedBox(width: 20),

                    Text(
                      'Munnur',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),

                    SizedBox(width: 20),

                    InkWell(
                      child: Icon(
                          FontAwesome.angle_right
                      ),

                      onTap: () {
                        if(mouthIndex < mouths.length - 1) {
                          setState(() {
                            mouthIndex++;
                          });
                        }
                      },
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                          FontAwesome.angle_left
                      ),

                      onTap: () {
                        if(eyebrowIndex > -1) {
                          setState(() {
                            eyebrowIndex--;
                          });
                        }
                      },
                    ),

                    SizedBox(width: 20),

                    Text(
                      'Augnbrýr',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),

                    SizedBox(width: 20),

                    InkWell(
                      child: Icon(
                          FontAwesome.angle_right
                      ),

                      onTap: () {
                        if(eyebrowIndex < eyebrows.length - 1) {
                          setState(() {
                            eyebrowIndex++;
                          });
                        }
                      },
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                          FontAwesome.angle_left
                      ),

                      onTap: () {
                        if(beardIndex > -1) {
                          setState(() {
                            beardIndex--;
                          });
                        }
                      },
                    ),

                    SizedBox(width: 20),

                    Text(
                      'Skegg',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),

                    SizedBox(width: 20),

                    InkWell(
                      child: Icon(
                          FontAwesome.angle_right
                      ),

                      onTap: () {
                        if(beardIndex < beards.length - 1) {
                          setState(() {
                            beardIndex++;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
