import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:flyingman_poc03/utils/local_system_time_util.dart';

class DigitalClockPage extends StatefulWidget {
  const DigitalClockPage({Key? key}) : super(key: key);

  @override
  _DigitalClockPage createState() => _DigitalClockPage();
}

class _DigitalClockPage extends State<DigitalClockPage> {
  LocalSystemTimeUtil _localSystemTimeUtil = new LocalSystemTimeUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("This is clock"),),
        body: TimerBuilder.periodic(Duration(milliseconds: 500),
            builder: (context) {
      _localSystemTimeUtil.setTimeToNow();
      //print(_localSystemTimeUtil.getSystemTime());
      return Text(
        _localSystemTimeUtil.getSystemTime(),
        style: TextStyle(
            color: Color(0xff2d386b),
            fontSize: 30,
            fontWeight: FontWeight.w700),
      );
    }));
  }
}
