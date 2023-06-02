import 'package:intl/intl.dart';

extension StringUtils on String {
  String capitalize() {
    return toUpperCase()[0] + substring(1);
  }

  DateTime formatToDate() {
    return DateFormat("yyyy-MM-dd HH:mm:ss", "pt-PT").parse(this);
  }
}

extension DateTimeUtils on DateTime {
  String toPatternString({String pattern = "dd/MM/yyyy HH:mm"}) {
    return DateFormat(pattern).format(this);
  }
}
