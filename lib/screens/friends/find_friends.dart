import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/views/user_view.dart';
import 'package:provider/provider.dart';

class FindFriends extends StatefulWidget {
  @override
  _FindFriendsState createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {
  List<UserProfile> userQueryResult = [];
  String searchQuery = '';


  void executeSearchQuery(User user) {
    setState(() async {
      userQueryResult = await DatabaseService(uid: user.uid).userSearch(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    /*return TextFormField(
      decoration: InputDecoration(
        labelText: 'Verð',
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
          ),
        ),
      ),

      validator: (val) =>
      val.isEmpty
          ? 'Sláðu inn verð'
          : null,

      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontFamily: 'Poppins',
      ),

      onChanged: (val) {
        setState(() {
          //    newAmount = int.parse(val);
        });
      },
    );

     */
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          color: Colors.grey[900],
          child: TextField(
            style: TextStyle(
                color: Colors.white
            ),
            decoration: InputDecoration(
              hintText: 'Leita að notendum',
              hintStyle: TextStyle(
                color: Colors.grey[500],
              ),
              prefixIcon: Icon(
                FontAwesomeIcons.search,
                color: Colors.white,
              ),
            ),
            onChanged: (val) {
              setState(() => searchQuery = val);
              executeSearchQuery(user);
            },
          ),
        ),

        userQueryResult.isNotEmpty ? Column(
          children: userQueryResult.map((user) {
            return UserView(
              user: user,
            );
          }).toList(),
        ) : Container()
      ],
    );
  }
}
