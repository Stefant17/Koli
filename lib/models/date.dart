// This class formats the date to suit our needs
class Date {
  var day;
  var month;
  var year;
  var weekday;

  List weekdays = [
    null, 'Mánudagur', 'Þriðjudagur', 'Miðvikudagur',
    'Fimmtudagur', 'Föstudagur', 'Laugadagur', 'Sunnudagur'
  ];

  Date(var currentDate) {
    day = currentDate.day;
    month = currentDate.month;
    year = currentDate.year;
    weekday = weekdays[currentDate.weekday];
  }

  String getCurrentDate() {
    return '$day/$month/$year';
  }

  String getCurrentWeekday() {
    return '$weekday';
  }
}