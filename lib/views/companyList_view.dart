import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/forms/edit_transaction_form.dart';
import 'package:koli/models/transaction.dart';
import 'package:koli/services/dataService.dart';
class CompanyView extends StatefulWidget {
  final curr_company;
  CompanyView({ this.curr_company });

   @override
  _CompanyViewState createState() => _CompanyViewState();
}


class _CompanyViewState extends State<CompanyView> {
  @override
  Widget build(BuildContext context) {
      return Container(
          margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    /*Container(
                      padding: EdgeInsets.all(15),

                      child: Icon(
                        Constants().categoryIcons[widget.curr_company['DefaultCategory']]['Icon'],
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(Constants().categoryIcons[widget.curr_company.get('DefaultCategory')]['Color']),
                      ),
                    ),*/
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.curr_company['Name'],
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 8.0),
              ],
            ),
          )
      );
  }
}
