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
}