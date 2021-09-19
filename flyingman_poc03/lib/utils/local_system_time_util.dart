import 'package:intl/intl.dart';

class LocalSystemTimeUtil{

  static DateTime _dateTime = DateTime.now();

  DateTime get dateTime => _dateTime;

  void setTimeToNow(){
    _dateTime = DateTime.now();
  }
  set dateTime(DateTime value) {
    _dateTime = value;
  }

  String getSystemTime() {
    return DateFormat("H:m:ss.S").format(_dateTime);
  }
}