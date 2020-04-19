import 'package:charts_flutter/flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Constants {
  List<List> menuList = [
    [FontAwesomeIcons.home, 'Heim'],
    [FontAwesomeIcons.fileContract, 'Yfirlit'],
    [FontAwesomeIcons.calendarDay, 'Dags yfirlit'],
    [FontAwesomeIcons.solidChartBar, 'Tölfræði'],
    [FontAwesomeIcons.award, 'Orður'],
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
}
