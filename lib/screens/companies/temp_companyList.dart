import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koli/models/company.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/views/companyList_view.dart';
import 'package:provider/provider.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/models/options_variables.dart';


import 'package:flutter/cupertino.dart';

class CompanyList extends StatefulWidget{
  @override
  _CompanyList createState() => _CompanyList();
}


List<DocumentSnapshot> allCompanies = [];



class _CompanyList extends State<CompanyList>{
  void companies = DatabaseService().companyCollection.getDocuments().then((val){
//    print('her');
  val.documents.forEach((f)=> {
    allCompanies.add(f)
    // ignore: sdk_version_set_literal
    //print(f.data)
  });
  print(allCompanies);
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: appBar(context, 'Prófíll'),
        body: ListView(
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: allCompanies.map((trans) => CompanyView(
                        curr_company: trans.data,
                        )).toList(),
                    ),
                  ]
              )
                  ]
              )
        );
  }
}

