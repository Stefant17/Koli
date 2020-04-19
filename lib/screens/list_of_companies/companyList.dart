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


import 'package:flutter/cupertino.dart';

class CompanyList extends Statefulwidget{
  @override
  _CompanyList createState() => _CompanyList();
}

class _CompanyList extends State<CompanyList>{
  List<String> companies = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: appBar(context, 'companiesList'),
         body: ListView(
            children: <Widget>[
                       Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: olderTransactions.map((trans) => TransactionView(
                                userTransaction: trans,
                                uid: user.uid,
                              )).toList(),),
                          ]
                        )
            ]
         )
    )
  }
}