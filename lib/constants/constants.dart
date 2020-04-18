import 'package:charts_flutter/flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Constants {
  List<List> menuList = [
    [FontAwesomeIcons.home, 'Heim'],
    [FontAwesomeIcons.fileContract, 'Yfirlit'],
    [FontAwesomeIcons.calendarDay, 'Dags yfirlit'],
    [FontAwesomeIcons.chartArea, 'Tölfræði'],
    [FontAwesomeIcons.award, 'Orður'],
    [FontAwesomeIcons.signOutAlt, 'Skrá út'],
    [FontAwesomeIcons.handshake, 'companies'],
  ];

  var categoryIcons = {
    'Matvörur': {
      'Icon': FontAwesomeIcons.shoppingBasket,
      'Color': 0xFF339989,
    },

    'Bensín': {
      'Icon': FontAwesomeIcons.gasPump,
      'Color': 0xFFD81E5B,
    },

    'Fatnaður': {
      'Icon': FontAwesomeIcons.redhat,
      'Color': 0xFF736CED,
    },

    'Raftæki': {
      'Icon': FontAwesomeIcons.plug,
      'Color': 0xFF540D6E,
    },

    'Húsgögn': {
      'Icon': FontAwesomeIcons.chair,
      'Color': 0xFF336699,
    },

    'Skyndibiti': {
      'Icon': FontAwesomeIcons.hamburger,
      'Color': 0xFF9EE493,
    }
  };
}
