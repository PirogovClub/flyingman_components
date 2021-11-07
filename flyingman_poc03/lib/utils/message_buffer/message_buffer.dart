import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flyingman_poc03/dto/domain/bme_sensor_data.dart';
import 'package:flyingman_poc03/dto/domain/sensor_data.dart';
import 'package:flyingman_poc03/utils/message_buffer/sensor_message.dart';
import 'package:flyingman_poc03/utils/message_buffer/sensor_message_provider.dart';
import 'package:flyingman_poc03/utils/states_dto.dart';
import 'package:http/http.dart';

import 'package:sqflite/sqflite.dart';

import '../storage.dart';

class MessageBuffer {
  List<SensorMessage> _sensor_messages = [];
  final SensorMessageProvider _sensorMessageProvider = SensorMessageProvider();
  final InfoStorage _infoStorage = InfoStorage();

  bool runningCommitNow = false;

  MessageBuffer() {}

  MessageBuffer returnThis() {
    return this;
  }

  Future<MessageBuffer> init() async {
    await _infoStorage.getFilePath().then(
        (value) => {_sensorMessageProvider.open(value + "/messageStorage.db")});

    Timer.periodic(Duration(seconds: 10), (timer) {
      resendMessages();
    });
    Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!runningCommitNow) {
        //bubblegum solution for not overlaping commits
        runningCommitNow = true;
        await _sensorMessageProvider.commitChanges();
        runningCommitNow = false;
      }
    });
    return this;
  }

  Future<MessageBuffer> close() async {
    await _sensorMessageProvider.close();
    return this;
  }

  Future<void> addMessageToBuffer(SensorMessage sensorMessage) async {
    //TODO: To move logic from storage to here
    sensorMessage.timeAdded = DateTime.now();
    _sensorMessageProvider.addInsertToBatch(sensorMessage);
  }

  resendMessages() async {
    print("before getting all messages to send");
    await _sensorMessageProvider
        .getAllSensorMessages()
        .then((messageList) async {
      for (var sensorMessage in messageList) {
        reSendMessage(sensorMessage);
      }
    });
    print("after sending all messages");
  }

  Future<Response> reSendMessage(SensorMessage sensorMessage) async {
    //To move logic from storage to here
    sensorMessage.timeLastRetry = DateTime.now();

    _sensorMessageProvider.update(sensorMessage);
    //print("sending sensorMessage:"+sensorMessage.toString());
    return sendMessageAndDeleteIfSuccessful(sensorMessage);
  }

  Future<Response> sendMessageAndDeleteIfSuccessful(
      SensorMessage sensorMessage) async {
    try {
      var response =
          await _infoStorage.saveSensorMessageToServer(sensorMessage);

      if (response.statusCode == 201) {
        _sensorMessageProvider.delete(sensorMessage.id);
        print("message deleted id:" + sensorMessage.id.toString());
      }
      return response;
    } on SocketException catch (e) {
      print("SocketException: " + e.toString());
    } on TimeoutException catch (e) {
      print("TimeoutException: " + e.toString());
    }
    return Response("phhhhh", 400);
  }

  Future<int> getAmountMessageInBuffer() {
    return _sensorMessageProvider.getAmountMessageInBuffer();
  }
}
