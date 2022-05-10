import 'package:intl/intl.dart';

class TimeUtils {
  static DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  //This function accepts a date and an integer.  The integer determines the date to be returned.
  //For example: if integer i is equals to 6,
  //it will return the date where Saturday falls given the passed date
  static DateTime getWeekDate(DateTime date, int i) {
    //return TimeUtils.getDate(date).subtract(Duration(days: date.weekday - i));
    return TimeUtils.getDate(date).add(Duration(days: i));
  }

  static getDate(DateTime date) {
    final currDay = DateTime(date.year, date.month, date.day);
    return currDay;
  }

  static String toStringDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return date;
  }

  static String getMonth(DateTime dateTime) {
    final month = DateFormat.MMM().format(dateTime);
    return month;
  }

  static String getDay(DateTime dateTime) {
    final day = dateTime.day;
    return '$day';
  }
}
