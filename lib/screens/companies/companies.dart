import 'package:flutter/material.dart';
import 'package:koli/models/company.dart';
import 'package:koli/models/user.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:provider/provider.dart';

class Companies extends StatelessWidget {
  List<Company> filterCarbonReducingCompanies(List<Company> companies) {
    List<Company> reducingCompanies = [];
    for(var i in companies) {
      if(i.co2Friendly) {
        reducingCompanies.add(i);
      }
    }

    return reducingCompanies;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: appBar(context, 'Fyrirtæki'),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            Text(
              'Kolefnisjafnandi Fyrirtæki',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),
            
            StreamBuilder<List<Company>>(
              stream: DatabaseService(uid: user.uid).companies,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  List<Company> companies = filterCarbonReducingCompanies(snapshot.data);

                  return Expanded(
                    child: ListView(
                      children: companies.map((com) {
                        return Text(com.name);
                      }).toList(),
                    ),
                  );
                } else {
                  return Text('Loading');
                }
              }
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
