import 'package:intl/intl.dart';

class TimeFormater {
  static timeFormater(time) {
    ;
    DateTime dateTime = time.toDate();
    final dateString = DateFormat('hh:mm:ss').format(dateTime);
    return dateString;
  }
}
