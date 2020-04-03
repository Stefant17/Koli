// This class formats the date to suit our needs
class Date {
  var day;
  var month;
  var year;

  var monthName;
  var weekday;

  List weekdays = [
    null, 'Mánudagur', 'Þriðjudagur', 'Miðvikudagur',
    'Fimmtudagur', 'Föstudagur', 'Laugardagur', 'Sunnudagur'
  ];

  List months = [
    null, 'Janúar', 'Febrúar', 'Mars', 'Apríl', 'Maí',
    'Júní', 'Júlí', 'Ágúst', 'September', 'Október',
    'Nóvember', 'Desember',
  ];

  Date(var currentDate) {
    day = currentDate.day;
    month = currentDate.month;
    year = currentDate.year;
    monthName = months[currentDate.month];
    weekday = weekdays[currentDate.weekday];
  }

  String getCurrentDate() {
    return '$day/$month/$year';
  }

  String getCurrentWeekday() {
    return '$weekday';
  }

  String getCurrentMonthName() {
    return '$monthName';
  }

  // Returns a list of the current month and the months that have passed this year
  List<String> getListOfMonthsToDate(int currentMonth) {
    List<String> monthList = [];
    for(var i = 1; i <= currentMonth; i++) {
      monthList.add(months[i]);
    }
    return monthList;
  }

  int getMonthNumberFromString(String month) {
    for(var i = 1; i < months.length; i++) {
      if(months[i] == month) {
        return i;
      }
    }

    return 0;
  }

  List getMonthList() {
    return months;
  }

  String getDayAndMonth() {
    return '$day. ${months[month]}';
  }
}