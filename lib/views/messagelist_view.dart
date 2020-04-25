import 'package:flutter/material.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/shared/appbar.dart';
import 'package:koli/shared/bottom_navbar.dart';

class MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final bottomBarIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Skilaboð'),
      body: Text('Skilaboð'),

      bottomNavigationBar: BottomBar(currentTab: bottomBarIndex),
      floatingActionButton: HomeFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}
