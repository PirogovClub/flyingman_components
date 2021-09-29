
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyingman_poc03/utils/storage.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:flyingman_poc03/utils/local_system_time_util.dart';


class SendToServerWidget extends StatefulWidget {
  const SendToServerWidget({Key? key}) : super(key: key);

  @override
  _SendToServerState createState() => _SendToServerState();

}

class _SendToServerState extends State<SendToServerWidget> {
  var _serverResponse;
  LocalSystemTimeUtil _localSystemTimeUtil = new LocalSystemTimeUtil();

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Server response: ${_serverResponse ?? "unknown"}',
            style: Theme.of(context).textTheme.bodyText1),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 42),
              child: ElevatedButton(
                child: const Text('SendQuery'),
                onPressed: _sendQuery,
              ),
            ),

          ],
        )
      ],
    );
  }

  Future<void> _sendQuery() async {

    CounterStorage counterStorage = new CounterStorage();
    final String serviceEnabledResult = await counterStorage.saveToDB("title");
    setState(() {
      _serverResponse = serviceEnabledResult;
    });
  }


}