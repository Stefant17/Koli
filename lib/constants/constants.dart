import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/screens/home/home_wrapper.dart';
import 'package:koli/shared/fade_page_transition.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class Constants {
  List<List> menuList = [
    [FontAwesomeIcons.home, 'Heim'],
    [FontAwesomeIcons.fileContract, 'Færslur'],
    [FontAwesomeIcons.calendarDay, 'Dags yfirlit'],
    [FontAwesomeIcons.solidChartBar, 'Tölfræði'],
    [FontAwesomeIcons.medal, 'Orður'],
    //[FontAwesomeIcons.handHoldingHeart, 'Góðgerðarmál'],
    [FontAwesomeIcons.seedling, 'Kolefnisjöfnun'],
    [FontAwesomeIcons.shoppingCart, 'Fyrirtæki'],
    [FontAwesomeIcons.chalkboardTeacher, 'Fræðsla'],
    [FontAwesomeIcons.signOutAlt, 'Skrá út'],
  ];

  var categoryIcons = {
    'Matvörur': {
      'Icon': FontAwesomeIcons.shoppingBasket,
      'Color': 0xFF339989,
    },

    'Bensín': {
      'Icon': FontAwesomeIcons.gasPump,
      'Color': 0xFFD81E5B //0xFFD81E5B,
    },

    'Fatnaður': {
      'Icon': FontAwesomeIcons.redhat,
      'Color': 0xFF736CED,
    },

    'Raftæki': {
      'Icon': FontAwesomeIcons.plug,
      'Color': 0xFF63458A //0xFF480355,
    },

    'Húsgögn': {
      'Icon': FontAwesomeIcons.chair,
      'Color': 0xFF19647E //0xFF40586F //0xFF336699,
    },

    'Skyndibiti': {
      'Icon': FontAwesomeIcons.hamburger,
      'Color': 0xFF36F1CD,
    },

    'Málefni': {
      'Icon': FontAwesomeIcons.handHoldingHeart,
      'Color': 0xFF3FA7D6,
    }
  };
/*
  Widget homeFAB(BuildContext context) {
    bool keyboardVisible = false;

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        keyboardVisible = visible;
      }
    );

    if(!keyboardVisible) {
      return FloatingActionButton(
        backgroundColor: Colors.grey[900],
        heroTag: 'HomeFAB',

        child: Icon(
          Icons.home
        ),

        onPressed: () {
          Navigator.push(
            context,
            FadePageTransition(
              widget: HomeWrapper(),
            )
          );
        },
      );
    } else {
      return SizedBox();
    }
  }

 */
}

class HomeFAB extends StatefulWidget {
  @override
  _HomeFABState createState() => _HomeFABState();
}

class _HomeFABState extends State<HomeFAB> {
  bool keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          keyboardVisible = visible;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    print('yo');
    if(!keyboardVisible) {
      return FloatingActionButton(
        backgroundColor: Colors.grey[900],
        heroTag: 'HomeFAB',

        child: Icon(
            Icons.home
        ),

        onPressed: () {
          Navigator.push(
            context,
            FadePageTransition(
              widget: HomeWrapper(),
            )
          );
        },
      );
    } else {
      return SizedBox();
    }
  }
}
