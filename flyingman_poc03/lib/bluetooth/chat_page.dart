import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flyingman_poc03/dto/domain/bme_sensor_data.dart';
import 'package:flyingman_poc03/main.dart';
import 'package:flyingman_poc03/utils/local_system_time_util.dart';
import 'package:flyingman_poc03/utils/message_buffer/sensor_message.dart';
import 'package:flyingman_poc03/utils/states_dto.dart';
import 'package:flyingman_poc03/utils/storage.dart';
import 'package:flyingman_poc03/utils/uid.dart';
import 'package:flyingman_poc03/widgets/clock.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:http/http.dart';

import '../main.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection? connection;
  LocalSystemTimeUtil _localSystemTimeUtil = new LocalSystemTimeUtil();
  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  bool isConnecting = true;

  bool get isConnected => (connection?.isConnected ?? false);
  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  /**
   * TODO:remove duplication method from maind
   */
  void changeRecordingStatus() {
    MyApp.messageBuffer.init().then((value) => {
          StateDto.setSaveToFile(!StateDto.saveToFile),
          /**
       * Left here
       */
        });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              Text(
                  (text) {
                    return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                  }(_message.text.trim()),
                  style: TextStyle(color: Colors.white)),
              Text(
                  (text) {
                    return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                  }("Some Timer Here"),
                  style: TextStyle(color: Colors.white))
            ]),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 252.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(20.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
      appBar: AppBar(
          title: (isConnecting
              ? Text('Connecting chat to ' + serverName + '...')
              : isConnected
                  ? Text('Live chat with ' + serverName)
                  : Text('Chat log with ' + serverName))),
      floatingActionButton: GFToggle(
        onChanged: (val) => {
          setState(() {
            changeRecordingStatus();
          })
        },
        value: StateDto.saveToFile,
        type: GFToggleType.ios,
        boxShape: BoxShape.circle,
        enabledText: 'ON',
        disabledText: 'OFF',
        enabledTrackColor: GFColors.DANGER,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            DigitalClockWidget(),
            Text(MyApp.uids.identifier,
                style: TextStyle(
                    color: Color(0xff2d386b),
                    fontSize: 30,
                    fontWeight: FontWeight.w700)),
            Flexible(
              child: ListView(
                  padding: const EdgeInsets.all(12.0),
                  controller: listScrollController,
                  children: list),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      style: const TextStyle(fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: isConnecting
                            ? 'Wait until connected...'
                            : isConnected
                                ? 'Type your message...'
                                : 'Chat got disconnected',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      enabled: isConnected,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: isConnected
                          ? () => _sendMessage(textEditingController.text)
                          : null),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String getBody(Response value) {
    print("body:" + value.body.toString());
    return value.body.toString();
  }

  _onDataReceived(Uint8List data) async {
    // Create message if there is end of object
    String dataString = String.fromCharCodes(data);
    //manage case when \r and \n came in different packages
    /*if (dataString.indexOf("\n") == 0) {
      dataString = "\r" + dataString;
    }
    if (dataString.indexOf("\r") == (dataString.length - 1)) {
      dataString = dataString.substring(0, dataString.length - 1);
    }

    List<String> messageparts = dataString.split("\r\n");
    */

    List<String> messageparts = dataString.split("|");

    if (messageparts.length == 1) {
      _messageBuffer = _messageBuffer + messageparts[0].replaceAll("\r\n", "");
    } else {
      for (int i = 0; i < (messageparts.length - 1); i++) {
        _messageBuffer = _messageBuffer + messageparts[i];
        _messageBuffer =
            _messageBuffer.substring(0, _messageBuffer.length - 1) +
                ",\"Time\":\"" +
                _localSystemTimeUtil.getSystemTime() +
                "\"" +
                ",\"loc\":\"" +
                "\"}";
        try {
          print("before decode:" + _messageBuffer);
          BmeSensorsData bmeSensorsData =
              BmeSensorsData.fromJson(jsonDecode(_messageBuffer));
          bmeSensorsData.measurement.user_device_id = MyApp.uids.identifier;
          //Uid().getDeviceDetails().then((value) => print("Device id "+ value.toString()));
          if (StateDto.saveToFile) {
            //print(_messageBuffer);
            var sensorMessage = SensorMessage(
                id: 0,
                messageBody: jsonEncode(bmeSensorsData.toJsonToBackEnd(),
                        toEncodable: InfoStorage.myEncode)
                    .toString(),
                done: false,
                endpoint: "http://69.87.221.132:8080/sensordata/add",
                timeAdded: DateTime.now(),
                timeLastRetry: DateTime.now(),
                messageType: "bme");

            MyApp.messageBuffer
                .addMessageToBuffer(sensorMessage)
                .then((value) => setState(() {
                      messages.add(_Message(
                          1, "Set to the queue: " + sensorMessage.toString()));
                    }));

            /* var s = "Queue length: " +
                (await MyApp.messageBuffer.getAmountMessageInBuffer())
                    .toString();
            print(s);*/
          }
        } on FormatException catch (e) {
          _messageBuffer = "";
          print("broken string found from sensor: " + e.toString());
        }

        setState(() {
          messages.add(_Message(1, _messageBuffer));
        });
        if (messages.length > 100) {
          messages.removeAt(0);
        }

        _messageBuffer = "";
      }
      _messageBuffer = messageparts[messageparts.length - 1];
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
