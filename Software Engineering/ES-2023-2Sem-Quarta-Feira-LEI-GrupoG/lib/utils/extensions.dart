import 'package:intl/intl.dart';

extension DateTimeUtils on DateTime {
  /// __getLastDayOfMonth()__
  ///
  /// Return the last day of the month as an [int]
  ///
  int getLastDayOfMonth() {
    return DateTime(year, month + 1, 0).day;
  }

  /// __getFirstDayOfTheWeek()__
  ///
  /// Return the first day of the week as an [int]
  ///
  int getFirstDayOfTheWeek() {
    return subtract(Duration(days: weekday - 1)).day;
  }

  /// __format({[String] pattern = "dd/MM/yyyy", [int] substring = -1})__
  ///
  /// Change format to a specific patern
  String format({String pattern = "dd/MM/yyyy", int substring = -1}) {
    try {
      return DateFormat(pattern)
          .format(this)
          .substring(0, substring == -1 ? null : substring);
    } catch (e) {
      return "";
    }
  }

  /// __isSameDay([DateTime] date)__
  ///
  /// Return boolean comparing year month day of a date
  ///
  bool isSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  /// __isWeekend()__
  ///
  /// Return boolean if the date is a weekend
  ///
  bool isWeekend() {
    return weekday == 6 || weekday == 7;
  }

  ///__isInBetweenInclusive([DateTime] date1, [DateTime] date2)__
  ///
  ///Receives two dates: [date1] and [date2]
  ///Returns if this date is in between or at the same time of those two dates received above
  /// ´´´dart
  /// date1.isAtSameMomentAs(this) || date2.isAtSameMomentAs(this) || isInBetween(date1, date2)
  /// ´´´
  bool isInBetweenInclusive(DateTime date1, DateTime date2) {
    return date1.isAtSameMomentAs(this) ||
        date2.isAtSameMomentAs(this) ||
        isInBetween(date1, date2);
  }

  ///__isInBetween([DateTime] date1, [DateTime] date2)__
  ///
  ///Receives two dates: [date1] and [date2]
  ///Returns if this date is in between the two dates received above
  /// ´´´dart:
  /// date1.isBefore(this) && date2.isAfter(this) || date2.isBefore(this) && date1.isAfter(this)
  /// ´´´
  bool isInBetween(DateTime date1, DateTime date2) {
    return date1.isBefore(this) && date2.isAfter(this) ||
        date2.isBefore(this) && date1.isAfter(this);
  }
}
