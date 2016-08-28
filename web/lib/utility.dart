library utility;

import 'package:intl/intl.dart' show DateFormat;

class Utility
{


  static String getDayOfMonthSuffix(int num)
  {
    if (num < 1 || num > 31) throw new Exception("The number doesn't represent a valid day of the month");
    if (num >= 11 && num <= 13)
    {
      return "th";
    }
    switch (num % 10)
    {
      case 1:  return "st";
      case 2:  return "nd";
      case 3:  return "rd";
      default: return "th";
    }
  }

  static final DateFormat dfDay = new DateFormat.d();
  static final DateFormat dfMonth = new DateFormat.MMMM();
  static final DateFormat dfMonthYear = new DateFormat.yMMMM();
}